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

#include "repo.h"

#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include <algorithm>
#include <atomic>
#include <cstdlib>
#include <cstring>
#include <exception>
#include <iterator>
#include <memory>
#include <type_traits>
#include <utility>

#include "arena.h"
#include "check.h"
#include "check_dir_mtime.h"
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

template <class T>
T Load(const std::atomic<T>& x) {
  return x.load(std::memory_order_relaxed);
}

template <class T>
void Store(std::atomic<T>& x, T v) {
  x.store(v, std::memory_order_relaxed);
}

template <class T>
T Inc(std::atomic<T>& x, T by = 1) {
  return x.fetch_add(by, std::memory_order_relaxed);
}

template <class T>
T Dec(std::atomic<T>& x) {
  return x.fetch_sub(1, std::memory_order_relaxed);
}

template <class T>
T Exchange(std::atomic<T>& x, T v) {
  return x.exchange(v, std::memory_order_relaxed);
}

const char* DeltaStr(git_delta_t t) {
  switch (t) {
    case GIT_DELTA_UNMODIFIED: return "unmodified";
    case GIT_DELTA_ADDED: return "added";
    case GIT_DELTA_DELETED: return "deleted";
    case GIT_DELTA_MODIFIED: return "modified";
    case GIT_DELTA_RENAMED: return "renamed";
    case GIT_DELTA_COPIED: return "copied";
    case GIT_DELTA_IGNORED: return "ignored";
    case GIT_DELTA_UNTRACKED: return "untracked";
    case GIT_DELTA_TYPECHANGE: return "typechange";
    case GIT_DELTA_UNREADABLE: return "unreadable";
    case GIT_DELTA_CONFLICTED: return "conflicted";
  }
  return "unknown";
}

}  // namespace

bool Repo::Shard::Contains(Str<> str, StringView path) const {
  if (str.Lt(path, start_s)) return false;
  if (end_s.empty()) return true;
  path.len = std::min(path.len, end_s.size());
  return !str.Lt(end_s, path);
}

Repo::Repo(git_repository* repo, Limits lim) : lim_(std::move(lim)), repo_(repo), tag_db_(repo) {
  if (lim_.max_num_untracked) {
    GlobalThreadPool()->Schedule([this] {
      bool check = CheckDirMtime(git_repository_path(repo_));
      std::unique_lock<std::mutex> lock(mutex_);
      CHECK(Load(untracked_cache_) == Tribool::kUnknown);
      Store(untracked_cache_, check ? Tribool::kTrue : Tribool::kFalse);
      cv_.notify_one();
    });
  } else {
    untracked_cache_ = Tribool::kFalse;
  }
}

Repo::~Repo() {
  {
    std::unique_lock<std::mutex> lock(mutex_);
    while (untracked_cache_ == Tribool::kUnknown) cv_.wait(lock);
  }
  if (git_index_) git_index_free(git_index_);
  git_repository_free(repo_);
}

IndexStats Repo::GetIndexStats(const git_oid* head, git_config* cfg) {
  ON_SCOPE_EXIT(this, orig_lim = lim_) { lim_ = orig_lim; };
  auto Off = [&](const char* name) {
    int val;
    if (git_config_get_bool(&val, cfg, name) || val) return false;
    LOG(INFO) << "Honoring git config option: " << name << " = false";
    return true;
  };
  if (!lim_.ignore_status_show_untracked_files && Off("status.showUntrackedFiles")) {
    lim_.max_num_untracked = 0;
  }
  if (!lim_.ignore_bash_show_untracked_files && Off("bash.showUntrackedFiles")) {
    lim_.max_num_untracked = 0;
  }
  if (!lim_.ignore_bash_show_dirty_state && Off("bash.showDirtyState")) {
    lim_.max_num_staged = 0;
    lim_.max_num_unstaged = 0;
    lim_.max_num_conflicted = 0;
  }

  if (git_index_) {
    int new_index;
    VERIFY(!git_index_read_ex(git_index_, 0, &new_index)) << GitError();
    if (new_index) {
      head_ = {};
      index_.reset();
    }
  } else {
    VERIFY(!git_repository_index(&git_index_, repo_)) << GitError();
    // Query an attribute (doesn't matter which) to initialize repo's attribute
    // cache. It's a workaround for synchronization bugs (data races) in libgit2
    // that result from lazy cache initialization without synchrnonization.
    // Thankfully, subsequent cache reads and writes are properly synchronized.
    const char* attr;
    VERIFY(!git_attr_get(&attr, repo_, 0, "x", "x")) << GitError();
  }

  UpdateShards();
  Store(error_, false);
  Store(unstaged_, {});
  Store(untracked_, {});
  Store(unstaged_deleted_, {});

  std::vector<const char*> dirty_candidates;
  const size_t index_size = git_index_entrycount(git_index_);

  if (!lim_.max_num_staged && !lim_.max_num_conflicted) {
    head_ = {};
    Store(staged_, {});
    Store(conflicted_, {});
    Store(staged_new_, {});
    Store(staged_deleted_, {});
    Store(skip_worktree_, {});
    Store(assume_unchanged_, {});
  } else if (head) {
    if (git_oid_equal(head, &head_)) {
      LOG(INFO) << "Index and HEAD unchanged; staged = " << Load(staged_)
                << ", conflicted = " << Load(conflicted_);
    } else {
      head_ = *head;
      Store(staged_, {});
      Store(conflicted_, {});
      Store(staged_new_, {});
      Store(staged_deleted_, {});
      Store(skip_worktree_, {});
      Store(assume_unchanged_, {});
      StartStagedScan(head);
    }
  } else {
    head_ = {};
    size_t staged = 0;
    size_t skip_worktree = 0;
    size_t assume_unchanged = 0;
    for (size_t i = 0; i != index_size; ++i) {
      const git_index_entry* entry = git_index_get_byindex_no_sort(git_index_, i);
      if (!(entry->flags_extended & GIT_INDEX_ENTRY_INTENT_TO_ADD)) ++staged;
      if (entry->flags_extended & GIT_INDEX_ENTRY_SKIP_WORKTREE) ++skip_worktree;
      if (entry->flags & GIT_INDEX_ENTRY_VALID) ++assume_unchanged;
    }
    Store(staged_, staged);
    Store(conflicted_, {});
    Store(staged_new_, staged);
    Store(staged_deleted_, {});
    Store(skip_worktree_, skip_worktree);
    Store(assume_unchanged_, assume_unchanged);
  }

  if (index_size <= lim_.dirty_max_index_size &&
      (lim_.max_num_unstaged || lim_.max_num_untracked)) {
    if (!index_) index_ = std::make_unique<Index>(repo_, git_index_);
    dirty_candidates = index_->GetDirtyCandidates({.include_untracked = lim_.max_num_untracked > 0,
                                                   .untracked_cache = Load(untracked_cache_)});
    if (dirty_candidates.empty()) {
      LOG(INFO) << "Clean repo: no dirty candidates";
    } else {
      LOG(INFO) << "Found " << dirty_candidates.size() << " dirty candidate(s) spanning from "
                << Print(dirty_candidates.front()) << " to " << Print(dirty_candidates.back());
    }
    StartDirtyScan(dirty_candidates);
  }

  Wait();
  VERIFY(!Load(error_));

  size_t num_staged = std::min(Load(staged_), lim_.max_num_staged);
  size_t num_unstaged = std::min(Load(unstaged_), lim_.max_num_unstaged);
  return {.index_size = index_size,
          .num_staged = num_staged,
          .num_unstaged = num_unstaged,
          .num_conflicted = std::min(Load(conflicted_), lim_.max_num_conflicted),
          .num_untracked = std::min(Load(untracked_), lim_.max_num_untracked),
          .num_staged_new = std::min(Load(staged_new_), num_staged),
          .num_staged_deleted = std::min(Load(staged_deleted_), num_staged),
          .num_unstaged_deleted = std::min(Load(unstaged_deleted_), num_unstaged),
          .num_skip_worktree = Load(skip_worktree_),
          .num_assume_unchanged = Load(assume_unchanged_)};
}

int Repo::OnDelta(const char* type, const git_diff_delta& d, std::atomic<size_t>& c1, size_t m1,
                  const std::atomic<size_t>& c2, size_t m2) {
  auto Msg = [&]() {
    const char* status = DeltaStr(d.status);
    std::ostringstream strm;
    strm << "Found " << type << " file";
    if (strcmp(status, type)) strm << " (" << status << ")";
    strm << ": " << Print(d.new_file.path);
    return strm.str();
  };

  size_t v = Inc(c1);
  if (v) {
    LOG(DEBUG) << Msg();
  } else {
    LOG(INFO) << Msg();
  }
  if (v + 1 < m1) return GIT_DIFF_DELTA_DO_NOT_INSERT;
  if (Load(c2) < m2) return GIT_DIFF_DELTA_DO_NOT_INSERT | GIT_DIFF_DELTA_SKIP_TYPE;
  return GIT_EUSER;
}

void Repo::StartDirtyScan(const std::vector<const char*>& paths) {
  if (paths.empty()) return;

  git_diff_options opt = GIT_DIFF_OPTIONS_INIT;
  opt.payload = this;
  opt.flags = GIT_DIFF_INCLUDE_TYPECHANGE_TREES | GIT_DIFF_SKIP_BINARY_CHECK |
              GIT_DIFF_DISABLE_PATHSPEC_MATCH | GIT_DIFF_EXEMPLARS;
  if (lim_.max_num_untracked) {
    opt.flags |= GIT_DIFF_INCLUDE_UNTRACKED;
    if (lim_.recurse_untracked_dirs) opt.flags |= GIT_DIFF_RECURSE_UNTRACKED_DIRS;
  } else {
    opt.flags |= GIT_DIFF_ENABLE_FAST_UNTRACKED_DIRS;
  }
  opt.ignore_submodules = GIT_SUBMODULE_IGNORE_DIRTY;
  opt.notify_cb = +[](const git_diff* diff, const git_diff_delta* delta,
                      const char* matched_pathspec, void* payload) -> int {
    if (delta->status == GIT_DELTA_CONFLICTED) return GIT_DIFF_DELTA_DO_NOT_INSERT;
    Repo* repo = static_cast<Repo*>(payload);
    if (Load(repo->error_)) return GIT_EUSER;
    if (delta->status == GIT_DELTA_UNTRACKED) {
      return repo->OnDelta("untracked", *delta, repo->untracked_, repo->lim_.max_num_untracked,
                           repo->unstaged_, repo->lim_.max_num_unstaged);
    } else {
      if (delta->status == GIT_DELTA_DELETED) Inc(repo->unstaged_deleted_);
      return repo->OnDelta("unstaged", *delta, repo->unstaged_, repo->lim_.max_num_unstaged,
                           repo->untracked_, repo->lim_.max_num_untracked);
    }
  };

  const Str<> str(git_index_is_case_sensitive(git_index_));
  auto shard = shards_.begin();
  for (auto p = paths.begin(); p != paths.end();) {
    opt.range_start = *p;
    opt.range_end = *p;
    opt.pathspec.strings = const_cast<char**>(&*p);
    opt.pathspec.count = 1;
    while (!shard->Contains(str, StringView(*p))) ++shard;
    while (++p != paths.end() && shard->Contains(str, StringView(*p))) {
      opt.range_end = *p;
      ++opt.pathspec.count;
    }
    RunAsync([this, opt]() {
      git_diff* diff = nullptr;
      LOG(DEBUG) << "git_diff_index_to_workdir from " << Print(opt.range_start) << " to "
                 << Print(opt.range_end);
      switch (git_diff_index_to_workdir(&diff, repo_, git_index_, &opt)) {
        case 0:
          git_diff_free(diff);
          break;
        case GIT_EUSER:
          break;
        default:
          LOG(ERROR) << "git_diff_index_to_workdir: " << GitError();
          throw Exception();
      }
    });
  }
}

void Repo::StartStagedScan(const git_oid* head) {
  git_commit* commit = nullptr;
  VERIFY(!git_commit_lookup(&commit, repo_, head)) << GitError();
  ON_SCOPE_EXIT(=) { git_commit_free(commit); };
  git_tree* tree = nullptr;
  VERIFY(!git_commit_tree(&tree, commit)) << GitError();

  git_diff_options opt = GIT_DIFF_OPTIONS_INIT;
  opt.flags = GIT_DIFF_EXEMPLARS | GIT_DIFF_INCLUDE_TYPECHANGE_TREES;
  opt.payload = this;
  opt.notify_cb = +[](const git_diff* diff, const git_diff_delta* delta,
                      const char* matched_pathspec, void* payload) -> int {
    Repo* repo = static_cast<Repo*>(payload);
    if (Load(repo->error_)) return GIT_EUSER;
    if (delta->status == GIT_DELTA_CONFLICTED) {
      return repo->OnDelta("conflicted", *delta, repo->conflicted_, repo->lim_.max_num_conflicted,
                           repo->staged_, repo->lim_.max_num_staged);
    } else {
      if (delta->status == GIT_DELTA_ADDED) Inc(repo->staged_new_);
      if (delta->status == GIT_DELTA_DELETED) Inc(repo->staged_deleted_);
      return repo->OnDelta("staged", *delta, repo->staged_, repo->lim_.max_num_staged,
                           repo->conflicted_, repo->lim_.max_num_conflicted);
    }
  };

  for (const Shard& shard : shards_) {
    RunAsync([this, tree, opt, shard]() mutable {
      size_t skip_worktree = 0;
      size_t assume_unchanged = 0;
      for (size_t i = shard.start_i; i != shard.end_i; ++i) {
        const git_index_entry* entry = git_index_get_byindex_no_sort(git_index_, i);
        if (entry->flags_extended & GIT_INDEX_ENTRY_SKIP_WORKTREE) ++skip_worktree;
        if (entry->flags & GIT_INDEX_ENTRY_VALID) ++assume_unchanged;
      }
      Inc(skip_worktree_, skip_worktree);
      Inc(assume_unchanged_, assume_unchanged);
      opt.range_start = shard.start_s.c_str();
      opt.range_end = shard.end_s.c_str();
      git_diff* diff = nullptr;
      LOG(DEBUG) << "git_diff_tree_to_index from " << Print(opt.range_start) << " to "
                 << Print(opt.range_end);
      switch (git_diff_tree_to_index(&diff, repo_, tree, git_index_, &opt)) {
        case 0:
          git_diff_free(diff);
          break;
        case GIT_EUSER:
          break;
        default:
          LOG(ERROR) << "git_diff_tree_to_index: " << GitError();
          throw Exception();
      }
    });
  }
}

void Repo::UpdateShards() {
  constexpr size_t kEntriesPerShard = 512;

  const Str<> str(git_index_is_case_sensitive(git_index_));
  size_t index_size = git_index_entrycount(git_index_);
  ON_SCOPE_EXIT(&) {
    LOG(INFO) << "Splitting " << index_size << " object(s) into " << shards_.size() << " shard(s)";
  };

  if (index_size <= kEntriesPerShard || GlobalThreadPool()->num_threads() < 2) {
    shards_ = {{
      .start_s = "",
      .end_s = "",
      .start_i = 0,
      .end_i = index_size}};
    return;
  }

  size_t shards =
      std::min(index_size / kEntriesPerShard + 1, 2 * GlobalThreadPool()->num_threads());
  shards_.clear();
  shards_.reserve(shards);
  std::string last_s;
  size_t last_i = 0;

  for (size_t i = 0; i != shards - 1; ++i) {
    size_t idx = (i + 1) * index_size / shards;
    std::string split = git_index_get_byindex_no_sort(git_index_, idx)->path;
    auto pos = split.find_last_of('/');
    if (pos == std::string::npos) continue;
    split = split.substr(0, pos + 1);
    Shard shard;
    shard.end_s = split;
    --shard.end_s.back();
    if (!str.Lt(last_s, shard.end_s)) continue;
    shard.start_s = std::move(last_s);
    last_s = std::move(split);
    shard.start_i = last_i;
    shard.end_i = idx;
    last_i = idx;
    shards_.push_back(std::move(shard));
  }
  shards_.push_back({
    .start_s = std::move(last_s),
    .end_s = "",
    .start_i = last_i,
    .end_i = index_size});

  CHECK(!shards_.empty());
  CHECK(shards_.size() <= shards);
  CHECK(shards_.front().start_s.empty());
  CHECK(shards_.front().start_i == 0);
  CHECK(shards_.back().end_s.empty());
  CHECK(shards_.back().end_i == index_size);
  for (size_t i = 0; i != shards_.size(); ++i) {
    if (i) {
      const git_index_entry* entry = git_index_get_byindex_no_sort(git_index_, shards_[i].start_i);
      CHECK(!std::memcmp(shards_[i].start_s.c_str(), entry->path, shards_[i].start_s.size()));
      CHECK(str.Lt(shards_[i - 1].end_s, shards_[i].start_s));
      CHECK(shards_[i - 1].end_i == shards_[i].start_i);
    }
    if (i != shards_.size() - 1) {
      CHECK(shards_[i].start_i < shards_[i].end_i);
      CHECK(str.Lt(shards_[i].start_s, shards_[i].end_s));
    }
  }
}

void Repo::DecInflight() {
  std::unique_lock<std::mutex> lock(mutex_);
  CHECK(Load(inflight_) > 0);
  if (Dec(inflight_) == 1) cv_.notify_one();
}

void Repo::RunAsync(std::function<void()> f) {
  Inc(inflight_);
  try {
    GlobalThreadPool()->Schedule([this, f = std::move(f)] {
      try {
        ON_SCOPE_EXIT(&) { DecInflight(); };
        f();
      } catch (const Exception&) {
        if (!Load(error_)) {
          std::unique_lock<std::mutex> lock(mutex_);
          if (!Load(error_)) {
            Store(error_, true);
            cv_.notify_one();
          }
        }
      }
    });
  } catch (...) {
    DecInflight();
    throw;
  }
}

void Repo::Wait() {
  std::unique_lock<std::mutex> lock(mutex_);
  while (inflight_) cv_.wait(lock);
}

std::future<std::string> Repo::GetTagName(const git_oid* target) {
  auto* promise = new std::promise<std::string>;
  std::future<std::string> res = promise->get_future();

  GlobalThreadPool()->Schedule([=] {
    ON_SCOPE_EXIT(&) { delete promise; };
    if (!target) {
      promise->set_value("");
      return;
    }
    try {
      promise->set_value(tag_db_.TagForCommit(*target));
    } catch (const Exception&) {
      promise->set_exception(std::current_exception());
    }
  });

  return res;
}

}  // namespace gitstatus
