// Copyright 2019 Roman Perepelitsa.
//
// This file is part of GitStatus.
//
// GitStatus is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// GitStatus is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with GitStatus. If not, see <https://www.gnu.org/licenses/>.

#include "tag_db.h"

#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include <algorithm>
#include <cstdlib>
#include <cstring>
#include <iterator>
#include <utility>

#include "check.h"
#include "dir.h"
#include "git.h"
#include "print.h"
#include "scope_guard.h"
#include "stat.h"
#include "string_cmp.h"
#include "thread_pool.h"
#include "timer.h"

namespace gitstatus {

namespace {

using namespace std::string_literals;

static constexpr char kTagPrefix[] = "refs/tags/";

constexpr int8_t kUnhex[256] = {
    0, 0,  0,  0,  0,  0,  0,  0, 0, 0, 0, 0, 0, 0, 0, 0,  // 0
    0, 0,  0,  0,  0,  0,  0,  0, 0, 0, 0, 0, 0, 0, 0, 0,  // 1
    0, 0,  0,  0,  0,  0,  0,  0, 0, 0, 0, 0, 0, 0, 0, 0,  // 2
    0, 1,  2,  3,  4,  5,  6,  7, 8, 9, 0, 0, 0, 0, 0, 0,  // 3
    0, 10, 11, 12, 13, 14, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0,  // 4
    0, 0,  0,  0,  0,  0,  0,  0, 0, 0, 0, 0, 0, 0, 0, 0,  // 5
    0, 10, 11, 12, 13, 14, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0   // 6
};

struct {
  bool operator()(const Tag* x, const git_oid& y) const {
    return std::memcmp(x->id.id, y.id, GIT_OID_RAWSZ) < 0;
  }
  bool operator()(const git_oid& x, const Tag* y) const {
    return std::memcmp(x.id, y->id.id, GIT_OID_RAWSZ) < 0;
  }
  bool operator()(const Tag* x, const Tag* y) const {
    return std::memcmp(x->id.id, y->id.id, GIT_OID_RAWSZ) < 0;
  }
} constexpr ById = {};

struct {
  bool operator()(const Tag* x, const char* y) const {
    return std::strcmp(x->name, y) < 0;
  }
  bool operator()(const char* x, const Tag* y) const {
    return std::strcmp(x, y->name) < 0;
  }
  bool operator()(const Tag* x, const Tag* y) const {
    return std::strcmp(x->name, y->name) < 0;
  }
} constexpr ByName = {};

void ParseOid(unsigned char* oid, const char* begin, const char* end) {
  VERIFY(end >= begin + GIT_OID_HEXSZ);
  for (size_t i = 0; i != GIT_OID_HEXSZ; i += 2) {
    *oid++ = kUnhex[+begin[i]] << 4 | kUnhex[+begin[i + 1]];
  }
}

const char* StripTag(const char* ref) {
  for (size_t i = 0; i != sizeof(kTagPrefix) - 1; ++i) {
    if (*ref++ != kTagPrefix[i]) return nullptr;
  }
  return ref;
}

git_refdb* RefDb(git_repository* repo) {
  git_refdb* res;
  VERIFY(!git_repository_refdb(&res, repo)) << GitError();
  return res;
}

}  // namespace

TagDb::TagDb(git_repository* repo)
    : repo_(repo),
      refdb_(RefDb(repo)),
      pack_(&pack_arena_),
      name2id_(&pack_arena_),
      id2name_(&pack_arena_) {
  CHECK(repo_ && refdb_);
}

TagDb::~TagDb() {
  Wait();
  git_refdb_free(refdb_);
}

std::string TagDb::TagForCommit(const git_oid& oid) {
  ReadLooseTags();
  UpdatePack();

  std::string res;

  std::string ref = "refs/tags/";
  size_t prefix_len = ref.size();
  for (const char* tag : loose_tags_) {
    ref.resize(prefix_len);
    ref += tag;
    if (res < tag && TagHasTarget(ref.c_str(), &oid)) res = tag;
  }

  if ((std::unique_lock<std::mutex>(mutex_), id2name_dirty_)) {
    for (auto it = name2id_.rbegin(); it != name2id_.rend(); ++it) {
      if (!memcmp((*it)->id.id, oid.id, GIT_OID_RAWSZ) && !IsLooseTag((*it)->name)) {
        if (res < (*it)->name) res = (*it)->name;
        break;
      }
    }
  } else {
    auto r = std::equal_range(id2name_.begin(), id2name_.end(), oid, ById);
    for (auto it = r.first; it != r.second; ++it) {
      if (!IsLooseTag((*it)->name) && res < (*it)->name) res = (*it)->name;
    }
  }

  return res;
}

void TagDb::ReadLooseTags() {
  loose_tags_.clear();
  loose_arena_.Reuse();

  std::string dirname = git_repository_path(repo_) + "refs/tags"s;
  int dir_fd = open(dirname.c_str(), O_RDONLY | O_DIRECTORY | O_CLOEXEC);
  if (dir_fd < 0) return;
  ON_SCOPE_EXIT(&) { CHECK(!close(dir_fd)) << Errno(); };
  // TODO: recursively traverse directories so that the file refs/tags/foo/bar gets interpreted
  // as the tag foo/bar. See https://github.com/romkatv/gitstatus/issues/254.
  (void)ListDir(dir_fd, loose_arena_, loose_tags_, /* precompose_unicode = */ false,
                /* case_sensitive = */ true);
}

void TagDb::UpdatePack() {
  auto Reset = [&] {
    auto Wipe = [](auto& x) {
      x.clear();
      x.shrink_to_fit();
    };
    Wait();
    Wipe(pack_);
    Wipe(name2id_);
    Wipe(id2name_);
    pack_arena_.Reuse();
    std::memset(&pack_stat_, 0, sizeof(pack_stat_));
  };

  std::string pack_path = git_repository_path(repo_) + "packed-refs"s;
  struct stat st;
  if (stat(pack_path.c_str(), &st)) {
    Reset();
    return;
  }
  if (StatEq(pack_stat_, st)) return;

  Reset();

  try {
    while (true) {
      LOG(INFO) << "Parsing " << Print(pack_path);
      int fd = open(pack_path.c_str(), O_RDONLY | O_CLOEXEC);
      VERIFY(fd >= 0);
      ON_SCOPE_EXIT(&) { CHECK(!close(fd)) << Errno(); };
      pack_.resize(st.st_size + 1);
      ssize_t n = read(fd, &pack_[0], st.st_size + 1);
      VERIFY(n >= 0) << Errno();
      VERIFY(!fstat(fd, &pack_stat_)) << Errno();
      if (!StatEq(st, pack_stat_)) {
        st = pack_stat_;
        continue;
      }
      VERIFY(n == st.st_size);
      pack_.pop_back();
      break;
    }
    ParsePack();
  } catch (const Exception&) {
    Reset();
    throw;
  }
}

void TagDb::ParsePack() {
  char* p = &pack_[0];
  char* e = p + pack_.size();

  // Usually packed-refs starts with the following line:
  //
  //   # pack-refs with: peeled fully-peeled sorted
  //
  // However, some users can produce pack-refs without this line.
  // See https://github.com/romkatv/powerlevel10k/issues/1428.
  // I don't know how they do it. Without the header line we cannot
  // assume that refs are sorted, which isn't a big deal because we
  // can just sort them. What's worse is that refs cannot be assumed
  // to be fully-peeled. We don't want to peel them, so we just drop
  // all tags.
  if (*p != '#') {
    LOG(WARN) << "packed-refs doesn't have a header. Won't resolve tags.";
    return;
  }

  char* eol = std::strchr(p, '\n');
  if (!eol) return;
  *eol = 0;
  if (!std::strstr(p, " fully-peeled") || !std::strstr(p, " sorted")) {
    LOG(WARN) << "packed-refs has unexpected header. Won't resolve tags.";
  }
  p = eol + 1;

  name2id_.reserve(pack_.size() / 128);
  id2name_.reserve(pack_.size() / 128);

  std::vector<Tag*> idx;
  idx.reserve(pack_.size() / 128);

  while (p != e) {
    Tag* tag = pack_arena_.Allocate<Tag>();
    ParseOid(tag->id.id, p, e);
    p += GIT_OID_HEXSZ;
    VERIFY(*p++ == ' ');
    const char* ref = p;
    VERIFY(p = std::strchr(p, '\n'));
    p[p[-1] == '\r' ? -1 : 0] = 0;
    ++p;
    if (*p == '^') {
      ParseOid(tag->id.id, p + 1, e);
      p += GIT_OID_HEXSZ + 1;
      if (p != e) {
        VERIFY((p = std::strchr(p, '\n')));
        ++p;
      }
    }
    tag->name = StripTag(ref);
    if (!tag->name) continue;
    name2id_.push_back(tag);
    id2name_.push_back(tag);
  }

  if (!std::is_sorted(name2id_.begin(), name2id_.end(), ByName)) {
    // "sorted" in the header of packed-refs promisses that this won't trigger.
    std::sort(name2id_.begin(), name2id_.end(), ByName);
  }

  id2name_dirty_ = true;
  GlobalThreadPool()->Schedule([this] {
    std::sort(id2name_.begin(), id2name_.end(), ById);
    std::unique_lock<std::mutex> lock(mutex_);
    CHECK(id2name_dirty_);
    id2name_dirty_ = false;
    cv_.notify_one();
  });
}

void TagDb::Wait() {
  std::unique_lock<std::mutex> lock(mutex_);
  while (id2name_dirty_) cv_.wait(lock);
}

bool TagDb::IsLooseTag(const char* name) const {
  return std::binary_search(loose_tags_.begin(), loose_tags_.end(), name,
                            [](const char* a, const char* b) { return std::strcmp(a, b) < 0; });
}

bool TagDb::TagHasTarget(const char* name, const git_oid* target) const {
  static constexpr size_t kMaxDerefCount = 10;

  git_reference* ref;
  if (git_refdb_lookup(&ref, refdb_, name)) return false;
  ON_SCOPE_EXIT(&) { git_reference_free(ref); };

  for (int i = 0; i != kMaxDerefCount && git_reference_type(ref) == GIT_REFERENCE_SYMBOLIC; ++i) {
    git_reference* dst;
    const char* ref_name = git_reference_name(ref);
    if (git_refdb_lookup(&dst, refdb_, ref_name)) {
      const char* tag_name = StripTag(ref_name);
      auto it = std::lower_bound(name2id_.begin(), name2id_.end(), tag_name, ByName);
      return it != name2id_.end() && !strcmp((*it)->name, tag_name) && !IsLooseTag(tag_name) &&
             git_oid_equal(&(*it)->id, target);
    }
    git_reference_free(ref);
    ref = dst;
  }

  if (git_reference_type(ref) == GIT_REFERENCE_SYMBOLIC) return false;
  const git_oid* oid = git_reference_target_peel(ref) ?: git_reference_target(ref);
  if (git_oid_equal(oid, target)) return true;

  for (int i = 0; i != kMaxDerefCount; ++i) {
    git_tag* tag;
    if (git_tag_lookup(&tag, repo_, oid)) return false;
    ON_SCOPE_EXIT(&) { git_tag_free(tag); };
    if (git_tag_target_type(tag) == GIT_OBJECT_COMMIT) {
      return git_oid_equal(git_tag_target_id(tag), target);
    }
    oid = git_tag_target_id(tag);
  }

  return false;
}

}  // namespace gitstatus
