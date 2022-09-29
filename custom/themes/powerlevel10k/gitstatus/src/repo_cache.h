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

#ifndef ROMKATV_GITSTATUS_REPO_CACHE_H_
#define ROMKATV_GITSTATUS_REPO_CACHE_H_

#include <map>
#include <memory>
#include <string>
#include <unordered_map>
#include <utility>

#include <git2.h>

#include "options.h"
#include "repo.h"
#include "time.h"

namespace gitstatus {

class RepoCache {
 public:
  explicit RepoCache(Limits lim) : lim_(std::move(lim)) {}
  Repo* Open(const std::string& dir, bool from_dotgit);
  void Free(Time cutoff);

 private:
  struct Entry;
  using Cache = std::unordered_map<std::string, std::unique_ptr<Entry>>;
  using LRU = std::multimap<Time, Cache::iterator>;

  void Erase(Cache::iterator it);

  Limits lim_;
  Cache cache_;
  LRU lru_;

  struct Entry : Repo {
    using Repo::Repo;
    LRU::iterator lru;
  };
};

}  // namespace gitstatus

#endif  // ROMKATV_GITSTATUS_REPO_CACHE_H_
