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

#ifndef ROMKATV_GITSTATUS_TAG_DB_H_
#define ROMKATV_GITSTATUS_TAG_DB_H_

#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include <git2.h>

#include <condition_variable>
#include <cstring>
#include <mutex>
#include <string>
#include <vector>

#include "arena.h"

namespace gitstatus {

struct Tag {
  const char* name;
  git_oid id;
};

class TagDb {
 public:
  explicit TagDb(git_repository* repo);
  TagDb(TagDb&&) = delete;
  ~TagDb();

  std::string TagForCommit(const git_oid& oid);

 private:
  void ReadLooseTags();
  void UpdatePack();
  void ParsePack();
  void Wait();

  bool IsLooseTag(const char* name) const;

  bool TagHasTarget(const char* name, const git_oid* target) const;

  git_repository* const repo_;
  git_refdb* const refdb_;

  Arena pack_arena_;
  struct stat pack_stat_ = {};
  WithArena<std::string> pack_;
  WithArena<std::vector<const Tag*>> name2id_;
  WithArena<std::vector<const Tag*>> id2name_;

  Arena loose_arena_;
  std::vector<char*> loose_tags_;

  std::mutex mutex_;
  std::condition_variable cv_;
  bool id2name_dirty_ = false;
};

}  // namespace gitstatus

#endif  // ROMKATV_GITSTATUS_TAG_DB_H_
