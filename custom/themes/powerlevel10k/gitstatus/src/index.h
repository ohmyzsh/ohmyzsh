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

#ifndef ROMKATV_GITSTATUS_INDEX_H_
#define ROMKATV_GITSTATUS_INDEX_H_

#include <sys/stat.h>

#include <git2.h>

#include <cstddef>
#include <string>
#include <vector>

#include "arena.h"
#include "options.h"
#include "string_view.h"
#include "tribool.h"

namespace gitstatus {

struct RepoCaps {
  RepoCaps(git_repository* repo, git_index* index);

  bool trust_filemode;
  bool has_symlinks;
  bool case_sensitive;
  bool precompose_unicode;
};

struct ScanOpts {
  bool include_untracked;
  Tribool untracked_cache;
};

struct IndexDir {
  explicit IndexDir(Arena* arena) : files(arena), subdirs(arena) {}

  StringView path;
  StringView basename;
  size_t depth = 0;
  struct stat st = {};
  WithArena<std::vector<const git_index_entry*>> files;
  WithArena<std::vector<StringView>> subdirs;

  Arena arena;
  std::vector<const char*> unmatched;
};

class Index {
 public:
  Index(git_repository* repo, git_index* index);

  std::vector<const char*> GetDirtyCandidates(const ScanOpts& opts);

 private:
  size_t InitDirs(git_index* index);
  void InitSplits(size_t total_weight);

  Arena arena_;
  WithArena<std::vector<IndexDir*>> dirs_;
  WithArena<std::vector<size_t>> splits_;
  git_index* git_index_;
  const char* root_dir_;
  RepoCaps caps_;
};

}  // namespace gitstatus

#endif  // ROMKATV_GITSTATUS_GIT_H_
