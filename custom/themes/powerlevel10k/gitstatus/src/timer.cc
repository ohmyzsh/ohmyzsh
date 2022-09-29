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

#include "timer.h"

#include <sys/resource.h>
#include <sys/time.h>
#include <time.h>

#include <cmath>
#include <limits>

#include "check.h"
#include "logging.h"

namespace gitstatus {

namespace {

double CpuTimeMs() {
  auto ToMs = [](const timeval& tv) { return 1e3 * tv.tv_sec + 1e-3 * tv.tv_usec; };
  rusage usage = {};
  CHECK(getrusage(RUSAGE_SELF, &usage) == 0) << Errno();
  return ToMs(usage.ru_utime) + ToMs(usage.ru_stime);
}

double WallTimeMs() {
  // An attempt to call clock_gettime on an ancient version of MacOS fails at runtime.
  // It's possible to detect the presence of clock_gettime at runtime but I don't have
  // an ancient MacOS to test the code. Hence this.
#ifdef __APPLE__
  return std::numeric_limits<double>::quiet_NaN();
#else
  struct timespec ts;
  clock_gettime(CLOCK_MONOTONIC, &ts);
  return 1e3 * ts.tv_sec + 1e-6 * ts.tv_nsec;
#endif
}

}  // namespace

void Timer::Start() {
  cpu_ = CpuTimeMs();
  wall_ = WallTimeMs();
}

void Timer::Report(const char* msg) {
  double cpu = CpuTimeMs() - cpu_;
  if (std::isnan(wall_)) {
    LOG(INFO) << "Timing for: " << msg << ": " << cpu << "ms cpu";
  } else {
    double wall = WallTimeMs() - wall_;
    LOG(INFO) << "Timing for: " << msg << ": " << cpu << "ms cpu, " << wall << "ms wall";
  }
  Start();
}

}  // namespace gitstatus
