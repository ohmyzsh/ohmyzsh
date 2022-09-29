#ifndef ROMKATV_GITSTATUS_TIME_H_
#define ROMKATV_GITSTATUS_TIME_H_

#include <chrono>

namespace gitstatus {

using Clock = std::chrono::steady_clock;
using Time = Clock::time_point;
using Duration = Clock::duration;

}  // namespace gitstatus

#endif  // ROMKATV_GITSTATUS_TIME_H_
