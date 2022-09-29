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

#include "logging.h"

#include <pthread.h>
#include <time.h>

#include <cerrno>
#include <cstdio>
#include <cstring>
#include <ctime>
#include <mutex>
#include <string>

namespace gitstatus {

namespace internal_logging {

namespace {

std::mutex g_log_mutex;

constexpr char kHexLower[] = {'0', '1', '2', '3', '4', '5', '6', '7',
                              '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};

void FormatThreadId(char (&out)[2 * sizeof(std::uintptr_t) + 1]) {
  std::uintptr_t tid = (std::uintptr_t)pthread_self();
  char* p = out + sizeof(out) - 1;
  *p = 0;
  do {
    --p;
    *p = kHexLower[tid & 0xF];
    tid >>= 4;
  } while (p != out);
}

void FormatCurrentTime(char (&out)[64]) {
  std::time_t time = std::time(nullptr);
  struct tm tm;
  if (localtime_r(&time, &tm) != &tm || std::strftime(out, sizeof(out), "%F %T", &tm) == 0) {
    std::strcpy(out, "undef");
  }
}

}  // namespace

LogStreamBase::LogStreamBase(const char* file, int line, LogLevel lvl)
    : errno_(errno), file_(file), line_(line), lvl_(LogLevelStr(lvl)) {
  strm_ = std::make_unique<std::ostringstream>();
}

void LogStreamBase::Flush() {
  {
    std::string msg = strm_->str();
    char tid[2 * sizeof(std::uintptr_t) + 1];
    FormatThreadId(tid);
    char time[64];
    FormatCurrentTime(time);

    std::unique_lock<std::mutex> lock(g_log_mutex);
    std::fprintf(stderr, "[%s %s %s %s:%d] %s\n", time, tid, lvl_, file_, line_, msg.c_str());
  }
  strm_.reset();
  errno = errno_;
}

std::ostream& operator<<(std::ostream& strm, Errno e) {
  // GNU C Library uses a buffer of 1024 characters for strerror(). Mimic to avoid truncations.
  char buf[1024];
  auto x = strerror_r(e.err, buf, sizeof(buf));
  // There are two versions of strerror_r with different semantics. We can figure out which
  // one we've got by looking at the result type.
  if (std::is_same<decltype(x), int>::value) {
    // XSI-compliant version.
    strm << (x ? "unknown error" : buf);
  } else if (std::is_same<decltype(x), char*>::value) {
    // GNU-specific version.
    strm << x;
  } else {
    // Something else entirely.
    strm << "unknown error";
  }
  return strm;
}

}  // namespace internal_logging

LogLevel g_min_log_level = INFO;

const char* LogLevelStr(LogLevel lvl) {
  switch (lvl) {
    case DEBUG:
      return "DEBUG";
    case INFO:
      return "INFO";
    case WARN:
      return "WARN";
    case ERROR:
      return "ERROR";
    case FATAL:
      return "FATAL";
  }
  return "UNKNOWN";
}

bool ParseLogLevel(const char* s, LogLevel& lvl) {
  if (!s)
    return false;
  else if (!std::strcmp(s, "DEBUG"))
    lvl = DEBUG;
  else if (!std::strcmp(s, "INFO"))
    lvl = INFO;
  else if (!std::strcmp(s, "WARN"))
    lvl = WARN;
  else if (!std::strcmp(s, "ERROR"))
    lvl = ERROR;
  else if (!std::strcmp(s, "FATAL"))
    lvl = FATAL;
  else
    return false;
  return true;
}

}  // namespace gitstatus
