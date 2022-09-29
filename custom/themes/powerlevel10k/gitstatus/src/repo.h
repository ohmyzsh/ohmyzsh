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

#ifndef ROMKATV_GITSTATUS_REPO_H_
#define ROMKATV_GITSTATUS_REPO_H_

#include <stddef.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include <git2.h>

#include <algorithm>
#include <atomic>
#include <condition_variable>
#include <cstddef>
#include <cstring>
#include <functional>
#include <future>
#include <memory>
#include <mutex>
#include <string>
#include <utility>
#include <vector>

#include "check.h"
#include "index.h"
#include "options.h"
#include "string_cmp.h"
#include "tag_db.h"
#include "time.h"

namespace gitstatus {

struct IndexStats {
  size_t index_size = 0;
  size_t num_staged = 0;
  size_t num_unstaged = 0;
  size_t num_conflicted = 0;
  size_t num_untracked = 0;
  size_t num_staged_new = 0;
  size_t num_staged_deleted = 0;
  size_t num_unstaged_deleted = 0;
  size_t num_skip_worktree = 0;
  size_t num_assume_unchanged = 0;
};

class Repo {
 public:
  explicit Repo(git_repository* repo, Limits lim);
  Repo(Repo&& other) = delete;
  ~Repo();

  git_repository* repo() const { return repo_; }

  // Head can be null, in which case has_staged will be false.
  IndexStats GetIndexStats(const git_oid* head, git_config* cfg);

  // Returns the last tag in lexicographical order whose target is equal to the given, or an
  // empty string. Target can be null, in which case the tag is empty.
  std::future<std::string> GetTagName(const git_oid* target);

 private:
  struct Shard {
    bool Contains(Str<> str, StringView path) const;
    std::string start_s;
    std::string end_s;
    size_t start_i;
    size_t end_i;
  };

  void UpdateShards();

  int OnDelta(const char* type, const git_diff_delta& d, std::atomic<size_t>& c1, size_t m1,
              const std::atomic<size_t>& c2, size_t m2);

  void StartStagedScan(const git_oid* head);
  void StartDirtyScan(const std::vector<const char*>& paths);

  void DecInflight();
  void RunAsync(std::function<void()> f);
  void Wait();

  Limits lim_;
  git_repository* const repo_;
  git_index* git_index_ = nullptr;
  std::vector<Shard> shards_;
  git_oid head_ = {};
  TagDb tag_db_;

  std::unique_ptr<Index> index_;

  std::mutex mutex_;
  std::condition_variable cv_;
  std::atomic<size_t> inflight_{0};
  std::atomic<bool> error_{false};
  std::atomic<size_t> staged_{0};
  std::atomic<size_t> unstaged_{0};
  std::atomic<size_t> conflicted_{0};
  std::atomic<size_t> untracked_{0};
  std::atomic<size_t> staged_new_{0};
  std::atomic<size_t> staged_deleted_{0};
  std::atomic<size_t> unstaged_deleted_{0};
  std::atomic<size_t> skip_worktree_{0};
  std::atomic<size_t> assume_unchanged_{0};
  std::atomic<Tribool> untracked_cache_{Tribool::kUnknown};
};

}  // namespace gitstatus

#endif  // ROMKATV_GITSTATUS_REPO_H_
