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

#ifndef ROMKATV_GITSTATUS_OPTIONS_H_
#define ROMKATV_GITSTATUS_OPTIONS_H_

#include <chrono>
#include <string>

#include "logging.h"
#include "time.h"

namespace gitstatus {

struct Limits {
  // Truncate commit summary if it's longer than this many bytes.
  size_t max_commit_summary_length = 256;
  // Report at most this many staged changes.
  size_t max_num_staged = 1;
  // Report at most this many unstaged changes.
  size_t max_num_unstaged = 1;
  // Report at most this many conflicted changes.
  size_t max_num_conflicted = 1;
  // Report at most this many untracked files.
  size_t max_num_untracked = 1;
  // If a repo has more files in its index than this, override max_num_unstaged and
  // max_num_untracked (but not max_num_staged) with zeros.
  size_t dirty_max_index_size = -1;
  // If true, report untracked files like `git status --untracked-files`.
  bool recurse_untracked_dirs = false;
  // Unless true, report zero untracked files for repositories with
  // status.showUntrackedFiles = false.
  bool ignore_status_show_untracked_files = false;
  // Unless true, report zero untracked files for repositories with
  // bash.showUntrackedFiles = false.
  bool ignore_bash_show_untracked_files = false;
  // Unless true, report zero staged, unstaged and conflicted changes for repositories with
  // bash.showDirtyState = false.
  bool ignore_bash_show_dirty_state = false;
};

struct Options : Limits {
  // Use this many threads to scan git workdir for unstaged and untracked files. Must be positive.
  size_t num_threads = 1;
  // If non-negative, check whether the specified file descriptor is locked when not receiving any
  // requests for one second; exit if it isn't locked.
  int lock_fd = -1;
  // If non-negative, send signal 0 to the specified PID when not receiving any requests for one
  // second; exit if signal sending fails.
  int parent_pid = -1;
  // Don't write entires to log whose log level is below this. Log levels in increasing order:
  // DEBUG, INFO, WARN, ERROR, FATAL.
  LogLevel log_level = INFO;
  // Close git repositories that haven't been used for this long. This is meant to release resources
  // such as memory and file descriptors. The next request for a repo that's been closed is much
  // slower than for a repo that hasn't been. Negative value means infinity.
  Duration repo_ttl = std::chrono::seconds(3600);
};

Options ParseOptions(int argc, char** argv);

}  // namespace gitstatus

#endif  // ROMKATV_GITSTATUS_OPTIONS_H_
