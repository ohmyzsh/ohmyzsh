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

#include "check_dir_mtime.h"

#include <fcntl.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#include <cerrno>
#include <cstring>
#include <ctime>
#include <string>
#include <vector>

#include "check.h"
#include "dir.h"
#include "logging.h"
#include "print.h"
#include "scope_guard.h"
#include "stat.h"

namespace gitstatus {

namespace {

constexpr char kDirPrefix[] = ".gitstatus.";

void Touch(const char* path) {
  int fd = creat(path, 0444);
  VERIFY(fd >= 0) << Errno();
  CHECK(!close(fd)) << Errno();
}

bool StatChanged(const char* path, const struct stat& prev) {
  struct stat cur;
  VERIFY(!lstat(path, &cur)) << Errno();
  return !StatEq(prev, cur);
}

void RemoveStaleDirs(const char* root_dir) {
  int dir_fd = open(root_dir, O_DIRECTORY | O_CLOEXEC);
  if (dir_fd < 0) return;
  ON_SCOPE_EXIT(&) { CHECK(!close(dir_fd)) << Errno(); };

  Arena arena;
  std::vector<char*> entries;
  const std::time_t now = std::time(nullptr);
  if (!ListDir(dir_fd, arena, entries,
               /* precompose_unicode = */ false,
               /* case_sensitive = */ true)) {
    return;
  }

  std::string path = root_dir;
  const size_t root_dir_len = path.size();

  for (const char* entry : entries) {
    if (std::strlen(entry) < std::strlen(kDirPrefix)) continue;
    if (std::memcmp(entry, kDirPrefix, std::strlen(kDirPrefix))) continue;

    struct stat st;
    if (fstatat(dir_fd, entry, &st, AT_SYMLINK_NOFOLLOW)) {
      LOG(WARN) << "Cannot stat " << Print(entry) << " in " << Print(root_dir) << ": " << Errno();
      continue;
    }
    if (MTim(st).tv_sec + 10 > now) continue;

    path.resize(root_dir_len);
    path += entry;
    size_t dir_len = path.size();

    path += "/b/1";
    if (unlink(path.c_str()) && errno != ENOENT) {
      LOG(WARN) << "Cannot unlink " << Print(path) << ": " << Errno();
      continue;
    }

    for (const char* d : {"/a/1", "/a", "/b", ""}) {
      path.resize(dir_len);
      path += d;
      if (rmdir(path.c_str()) && errno != ENOENT) {
        LOG(WARN) << "Cannot remove " << Print(path) << ": " << Errno();
        break;
      }
    }
  }
}

}  // namespace

bool CheckDirMtime(const char* root_dir) {
  try {
    RemoveStaleDirs(root_dir);

    std::string tmp = std::string() + root_dir + kDirPrefix + "XXXXXX";
    VERIFY(mkdtemp(&tmp[0])) << Errno();
    ON_SCOPE_EXIT(&) { rmdir(tmp.c_str()); };

    std::string a_dir = tmp + "/a";
    VERIFY(!mkdir(a_dir.c_str(), 0755)) << Errno();
    ON_SCOPE_EXIT(&) { rmdir(a_dir.c_str()); };
    struct stat a_st;
    VERIFY(!lstat(a_dir.c_str(), &a_st)) << Errno();

    std::string b_dir = tmp + "/b";
    VERIFY(!mkdir(b_dir.c_str(), 0755)) << Errno();
    ON_SCOPE_EXIT(&) { rmdir(b_dir.c_str()); };
    struct stat b_st;
    VERIFY(!lstat(b_dir.c_str(), &b_st)) << Errno();

    while (sleep(1)) {
      // zzzz
    }

    std::string a1 = a_dir + "/1";
    VERIFY(!mkdir(a1.c_str(), 0755)) << Errno();
    ON_SCOPE_EXIT(&) { rmdir(a1.c_str()); };
    if (!StatChanged(a_dir.c_str(), a_st)) {
      LOG(WARN) << "Creating a directory doesn't change mtime of the parent: " << Print(root_dir);
      return false;
    }

    std::string b1 = b_dir + "/1";
    Touch(b1.c_str());
    ON_SCOPE_EXIT(&) { unlink(b1.c_str()); };
    if (!StatChanged(b_dir.c_str(), b_st)) {
      LOG(WARN) << "Creating a file doesn't change mtime of the parent: " << Print(root_dir);
      return false;
    }

    LOG(INFO) << "All mtime checks have passes. Enabling untracked cache: " << Print(root_dir);
    return true;
  } catch (const Exception&) {
    LOG(WARN) << "Error while testing for mtime capability: " << Print(root_dir);
    return false;
  }
}

}  // namespace gitstatus
