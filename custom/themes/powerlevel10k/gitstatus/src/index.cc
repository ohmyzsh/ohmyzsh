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

#include "index.h"

#include <dirent.h>
#include <fcntl.h>
#include <unistd.h>

#include <algorithm>
#include <condition_variable>
#include <cstdint>
#include <cstring>
#include <iomanip>
#include <iterator>
#include <mutex>
#include <stack>

#include "algorithm.h"
#include "check.h"
#include "dir.h"
#include "git.h"
#include "index.h"
#include "print.h"
#include "scope_guard.h"
#include "stat.h"
#include "string_cmp.h"
#include "thread_pool.h"

namespace gitstatus {

namespace {

void CommonDir(Str<> str, const char* a, const char* b, size_t* dir_len, size_t* dir_depth) {
  *dir_len = 0;
  *dir_depth = 0;
  for (size_t i = 1; str.Eq(*a, *b) && *a; ++i, ++a, ++b) {
    if (*a == '/') {
      *dir_len = i;
      ++*dir_depth;
    }
  }
}

size_t Weight(const IndexDir& dir) { return 1 + dir.subdirs.size() + dir.files.size(); }

bool MTimeEq(const git_index_time& index, const struct timespec& workdir) {
  if (index.seconds != workdir.tv_sec) return false;
  if (int64_t{index.nanoseconds} == workdir.tv_nsec) return true;
#ifdef GITSTATUS_ZERO_NSEC
  return index.nanoseconds == 0;
#else
  return false;
#endif
}

bool IsModified(const git_index_entry* entry, const struct stat& st, const RepoCaps& caps) {
  mode_t mode = st.st_mode;
  if (S_ISREG(mode)) {
    if (!caps.has_symlinks && S_ISLNK(entry->mode)) {
      mode = entry->mode;
    } else if (!caps.trust_filemode) {
      mode = entry->mode;
    } else {
      mode = S_IFREG | (mode & 0100 ? 0755 : 0644);
    }
  } else {
    mode &= S_IFMT;
  }

  bool res = false;

#define COND(field, cond...) \
  if (cond) {                \
  } else                     \
    res = true,              \
    LOG(DEBUG) << "Dirty candidate (modified): " << Print(entry->path) << ": " #field " "

  COND(ino, !entry->ino || entry->ino == static_cast<std::uint32_t>(st.st_ino))
      << entry->ino << " => " << static_cast<std::uint32_t>(st.st_ino);

  COND(stage, GIT_INDEX_ENTRY_STAGE(entry) == 0) << "=> " << GIT_INDEX_ENTRY_STAGE(entry);
  COND(fsize, int64_t{entry->file_size} == st.st_size) << entry->file_size << " => " << st.st_size;
  COND(mtime, MTimeEq(entry->mtime, MTim(st))) << Print(entry->mtime) << " => " << Print(MTim(st));
  COND(mode, entry->mode == mode) << std::oct << entry->mode << " => " << std::oct << mode;

#undef COND

  return res;
}

int OpenDir(int parent_fd, const char* name) {
  return openat(parent_fd, name, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
}

void OpenTail(int* fds, size_t nfds, int root_fd, StringView dirname, Arena& arena) {
  CHECK(fds && nfds && root_fd >= 0);
  std::fill(fds, fds + nfds, -1);
  if (!dirname.len) return;
  CHECK(dirname.len > 1);
  CHECK(dirname.ptr[0] != '/');
  CHECK(dirname.ptr[dirname.len - 1] == '/');

  char* begin = arena.StrDup(dirname.ptr, dirname.len - 1);
  WithArena<std::vector<const char*>> subdirs(&arena);
  subdirs.reserve(nfds + 1);

  for (char* sep = begin + dirname.len - 1; subdirs.size() < nfds;) {
    sep = FindLast(begin, sep, '/');
    if (sep == begin) break;
    *sep = 0;
    subdirs.push_back(sep + 1);
  }
  subdirs.push_back(begin);
  if (subdirs.size() < nfds + 1) subdirs.push_back(".");
  CHECK(subdirs.size() <= nfds + 1);

  for (size_t i = subdirs.size(); i != 1; --i) {
    const char* path = subdirs[i - 1];
    if ((root_fd = OpenDir(root_fd, path)) < 0) {
      for (; i != subdirs.size(); ++i) {
        CHECK(!close(fds[i - 1])) << Errno();
        fds[i - 1] = -1;
      }
      return;
    }
    fds[i - 2] = root_fd;
  }
}

std::vector<const char*> ScanDirs(git_index* index, int root_fd, IndexDir* const* begin,
                                  IndexDir* const* end, const RepoCaps& caps,
                                  const ScanOpts& opts) {
  const Str<> str(caps.case_sensitive);

  Arena arena;
  std::vector<const char*> dirty_candidates;
  std::vector<char*> entries;
  entries.reserve(128);

  auto AddCandidate = [&](const char* kind, const char* path) {
    if (kind) LOG(DEBUG) << "Dirty candidate (" << kind << "): " << Print(path);
    dirty_candidates.push_back(path);
  };

  constexpr ssize_t kDirStackSize = 5;
  int dir_fd[kDirStackSize];
  std::fill(std::begin(dir_fd), std::end(dir_fd), -1);
  auto Close = [](int& fd) {
    if (fd >= 0) {
      CHECK(!close(fd)) << Errno();
      fd = -1;
    }
  };
  auto CloseAll = [&] { std::for_each(std::begin(dir_fd), std::end(dir_fd), Close); };
  ON_SCOPE_EXIT(&) { CloseAll(); };
  if (begin != end) OpenTail(dir_fd, kDirStackSize, root_fd, (*begin)->path, arena);

  for (IndexDir* const* it = begin; it != end; ++it) {
    IndexDir& dir = **it;

    auto Basename = [&](const git_index_entry* e) { return e->path + dir.path.len; };

    auto AddUnmached = [&](StringView basename) {
      if (!basename.len) {
        dir.st = {};
        dir.unmatched.clear();
        dir.arena.Reuse();
      } else if (str.Eq(basename, StringView(".git/"))) {
        return;
      }
      char* path = dir.arena.StrCat(dir.path, basename);
      dir.unmatched.push_back(path);
      AddCandidate(basename.len ? "new" : "unreadable", path);
    };

    auto StatFiles = [&]() {
      struct stat st;
      for (const git_index_entry* file : dir.files) {
        if (fstatat(*dir_fd, Basename(file), &st, AT_SYMLINK_NOFOLLOW)) {
          AddCandidate(errno == ENOENT ? "deleted" : "unreadable", file->path);
        } else if (IsModified(file, st, caps)) {
          AddCandidate(nullptr, file->path);
        }
      }
    };

    ssize_t d = 0;
    if ((it == begin || (d = it[-1]->depth + 1 - dir.depth) < kDirStackSize) && dir_fd[d] >= 0) {
      CHECK(d >= 0);
      int fd = OpenDir(dir_fd[d], arena.StrDup(dir.basename.ptr, dir.basename.len));
      for (ssize_t i = 0; i != d; ++i) Close(dir_fd[i]);
      std::rotate(dir_fd, dir_fd + (d ? d : kDirStackSize) - 1, dir_fd + kDirStackSize);
      Close(*dir_fd);
      *dir_fd = fd;
    } else {
      CloseAll();
      if (dir.path.len) {
        CHECK(dir.path.ptr[0] != '/');
        CHECK(dir.path.ptr[dir.path.len - 1] == '/');
        *dir_fd = OpenDir(root_fd, arena.StrDup(dir.path.ptr, dir.path.len - 1));
      } else {
        VERIFY((*dir_fd = dup(root_fd)) >= 0) << Errno();
      }
    }
    if (*dir_fd < 0) {
      CloseAll();
      AddUnmached("");
      continue;
    }

    if (!opts.include_untracked) {
      StatFiles();
      continue;
    }

    if (opts.untracked_cache != Tribool::kFalse) {
      struct stat st;
      if (fstat(*dir_fd, &st)) {
        AddUnmached("");
        continue;
      }
      if (opts.untracked_cache == Tribool::kTrue && StatEq(st, dir.st)) {
        StatFiles();
        for (const char* path : dir.unmatched) AddCandidate("new", path);
        continue;
      }
      dir.st = st;
    }

    entries.clear();
    arena.Reuse();
    if (!ListDir(*dir_fd, arena, entries, caps.precompose_unicode, caps.case_sensitive)) {
      AddUnmached("");
      continue;
    }
    dir.unmatched.clear();
    dir.arena.Reuse();

    const git_index_entry* const* file = dir.files.data();
    const git_index_entry* const* file_end = file + dir.files.size();
    const StringView* subdir = dir.subdirs.data();
    const StringView* subdir_end = subdir + dir.subdirs.size();

    for (char* entry : entries) {
      bool matched = false;

      for (; file != file_end; ++file) {
        int cmp = str.Cmp(Basename(*file), entry);
        if (cmp < 0) {
          AddCandidate("deleted", (*file)->path);
        } else if (cmp == 0) {
          struct stat st;
          if (fstatat(*dir_fd, entry, &st, AT_SYMLINK_NOFOLLOW)) {
            AddCandidate("unreadable", (*file)->path);
          } else if (IsModified(*file, st, caps)) {
            AddCandidate(nullptr, (*file)->path);
          }
          matched = true;
          ++file;
          break;
        } else {
          break;
        }
      }

      if (matched) continue;

      for (; subdir != subdir_end; ++subdir) {
        int cmp = str.Cmp(*subdir, entry);
        if (cmp > 0) break;
        if (cmp == 0) {
          matched = true;
          ++subdir;
          break;
        }
      }

      if (!matched) {
        StringView basename(entry);
        if (entry[-1] == DT_DIR) entry[basename.len++] = '/';
        AddUnmached(basename);
      }
    }

    for (; file != file_end; ++file) AddCandidate("deleted", (*file)->path);
  }

  return dirty_candidates;
}

}  // namespace

RepoCaps::RepoCaps(git_repository* repo, git_index* index) {
  trust_filemode = git_index_is_filemode_trustworthy(index);
  has_symlinks = git_index_supports_symlinks(index);
  case_sensitive = git_index_is_case_sensitive(index);
  precompose_unicode = git_index_precompose_unicode(index);
  LOG(DEBUG) << "Repository capabilities for " << Print(git_repository_workdir(repo)) << ": "
             << "is_filemode_trustworthy = " << std::boolalpha << trust_filemode << ", "
             << "index_supports_symlinks = " << std::boolalpha << has_symlinks << ", "
             << "index_is_case_sensitive = " << std::boolalpha << case_sensitive << ", "
             << "precompose_unicode = " << std::boolalpha << precompose_unicode;
}

Index::Index(git_repository* repo, git_index* index)
    : dirs_(&arena_),
      splits_(&arena_),
      git_index_(index),
      root_dir_(git_repository_workdir(repo)),
      caps_(repo, index) {
  size_t total_weight = InitDirs(index);
  InitSplits(total_weight);
}

size_t Index::InitDirs(git_index* index) {
  const Str<> str(git_index_is_case_sensitive(index));
  const size_t index_size = git_index_entrycount(index);
  dirs_.reserve(index_size / 8);
  std::stack<IndexDir*> stack;
  stack.push(arena_.DirectInit<IndexDir>(&arena_));

  size_t total_weight = 0;
  auto PopDir = [&] {
    CHECK(!stack.empty());
    IndexDir* top = stack.top();
    CHECK(top->depth + 1 == stack.size());
    if (!std::is_sorted(top->subdirs.begin(), top->subdirs.end(), str.Lt)) {
      StrSort(top->subdirs.begin(), top->subdirs.end(), str.case_sensitive);
    }
    total_weight += Weight(*top);
    dirs_.push_back(top);
    stack.pop();
  };

  for (size_t i = 0; i != index_size; ++i) {
    const git_index_entry* entry = git_index_get_byindex_no_sort(index, i);
    IndexDir* prev = stack.top();
    size_t common_len, common_depth;
    CommonDir(str, prev->path.ptr, entry->path, &common_len, &common_depth);
    CHECK(common_depth <= prev->depth);

    for (size_t i = common_depth; i != prev->depth; ++i) PopDir();

    for (const char* p = entry->path + common_len; (p = std::strchr(p, '/')); ++p) {
      IndexDir* top = stack.top();
      StringView subdir(entry->path + top->path.len, p);
      top->subdirs.push_back(subdir);
      IndexDir* dir = arena_.DirectInit<IndexDir>(&arena_);
      dir->path = StringView(entry->path, p - entry->path + 1);
      dir->basename = subdir;
      dir->depth = stack.size();
      CHECK(dir->path.ptr[dir->path.len - 1] == '/');
      stack.push(dir);
    }

    CHECK(!stack.empty());
    IndexDir* dir = stack.top();
    dir->files.push_back(entry);
  }

  CHECK(!stack.empty());
  do {
    PopDir();
  } while (!stack.empty());
  std::reverse(dirs_.begin(), dirs_.end());

  return total_weight;
}

void Index::InitSplits(size_t total_weight) {
  constexpr size_t kMinShardWeight = 512;
  const size_t kNumShards = 16 * GlobalThreadPool()->num_threads();
  const size_t shard_weight = std::max(kMinShardWeight, total_weight / kNumShards);

  splits_.reserve(kNumShards + 1);
  splits_.push_back(0);

  for (size_t i = 0, w = 0; i != dirs_.size(); ++i) {
    w += Weight(*dirs_[i]);
    if (w >= shard_weight) {
      w = 0;
      splits_.push_back(i + 1);
    }
  }

  if (splits_.back() != dirs_.size()) splits_.push_back(dirs_.size());
  CHECK(splits_.size() <= kNumShards + 1);
  CHECK(std::is_sorted(splits_.begin(), splits_.end()));
  CHECK(std::adjacent_find(splits_.begin(), splits_.end()) == splits_.end());
}

std::vector<const char*> Index::GetDirtyCandidates(const ScanOpts& opts) {
  int root_fd = open(root_dir_, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
  VERIFY(root_fd >= 0);
  ON_SCOPE_EXIT(&) { CHECK(!close(root_fd)) << Errno(); };

  CHECK(!splits_.empty());

  std::mutex mutex;
  std::condition_variable cv;
  size_t inflight = splits_.size() - 1;
  bool error = false;
  std::vector<const char*> res;

  for (size_t i = 0; i != splits_.size() - 1; ++i) {
    size_t from = splits_[i];
    size_t to = splits_[i + 1];

    GlobalThreadPool()->Schedule([&, from, to]() {
      ON_SCOPE_EXIT(&) {
        std::unique_lock<std::mutex> lock(mutex);
        CHECK(inflight);
        if (--inflight == 0) cv.notify_one();
      };
      try {
        std::vector<const char*> candidates =
            ScanDirs(git_index_, root_fd, dirs_.data() + from, dirs_.data() + to, caps_, opts);
        if (!candidates.empty()) {
          std::unique_lock<std::mutex> lock(mutex);
          res.insert(res.end(), candidates.begin(), candidates.end());
        }
      } catch (const Exception&) {
        std::unique_lock<std::mutex> lock(mutex);
        error = true;
      }
    });
  }

  {
    std::unique_lock<std::mutex> lock(mutex);
    while (inflight) cv.wait(lock);
  }

  VERIFY(!error);
  StrSort(res.begin(), res.end(), git_index_is_case_sensitive(git_index_));
  auto StrEq = [](const char* a, const char* b) { return !strcmp(a, b); };
  res.erase(std::unique(res.begin(), res.end(), StrEq), res.end());
  return res;
}

}  // namespace gitstatus
