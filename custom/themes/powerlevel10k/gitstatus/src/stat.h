#ifndef ROMKATV_GITSTATUS_STAT_H_
#define ROMKATV_GITSTATUS_STAT_H_

#include <sys/stat.h>

namespace gitstatus {

inline const struct timespec& MTim(const struct stat& s) {
#ifdef __APPLE__
  return s.st_mtimespec;
#else
  return s.st_mtim;
#endif
}

inline bool StatEq(const struct stat& x, const struct stat& y) {
  return MTim(x).tv_sec == MTim(y).tv_sec && MTim(x).tv_nsec == MTim(y).tv_nsec &&
         x.st_size == y.st_size && x.st_ino == y.st_ino && x.st_mode == y.st_mode;
}

}  // namespace gitstatus

#endif  // ROMKATV_GITSTATUS_STAT_H_
