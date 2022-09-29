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

#ifndef ROMKATV_GITSTATUS_PRINT_H_
#define ROMKATV_GITSTATUS_PRINT_H_

#include <sys/stat.h>

#include <iomanip>
#include <ostream>
#include <string>
#include <type_traits>
#include <utility>
#include <vector>

#include <git2.h>

#include "string_view.h"
#include "strings.h"

namespace gitstatus {

template <class T>
struct Printable {
  const T& value;
};

template <class T>
Printable<T> Print(const T& val) {
  return {val};
}

template <class T>
std::ostream& operator<<(std::ostream& strm, const Printable<T>& p) {
  static_assert(!std::is_pointer<std::decay_t<T>>(), "");
  return strm << p.value;
}

inline std::ostream& operator<<(std::ostream& strm, const Printable<StringView>& p) {
  Quote(strm, p.value.ptr, p.value.ptr + p.value.len);
  return strm;
}

inline std::ostream& operator<<(std::ostream& strm, const Printable<std::string>& p) {
  Quote(strm, p.value.data(), p.value.data() + p.value.size());
  return strm;
}

inline std::ostream& operator<<(std::ostream& strm, const Printable<const char*>& p) {
  Quote(strm, p.value, p.value ? p.value + std::strlen(p.value) : nullptr);
  return strm;
}

inline std::ostream& operator<<(std::ostream& strm, const Printable<char*>& p) {
  Quote(strm, p.value, p.value ? p.value + std::strlen(p.value) : nullptr);
  return strm;
}

template <class T, class U>
std::ostream& operator<<(std::ostream& strm, const Printable<std::pair<T, U>>& p) {
  return strm << '{' << Print(p.value.first) << ", " << Print(p.value.second) << '}';
}

template <class T>
std::ostream& operator<<(std::ostream& strm, const Printable<std::vector<T>>& p) {
  strm << '[';
  for (size_t i = 0; i != p.value.size(); ++i) {
    if (i) strm << ", ";
    strm << Print(p.value[i]);
  }
  strm << ']';
  return strm;
}

inline std::ostream& operator<<(std::ostream& strm, const Printable<struct timespec>& p) {
  strm << p.value.tv_sec << '.' << std::setw(9) << std::setfill('0') << p.value.tv_nsec;
  return strm;
}

inline std::ostream& operator<<(std::ostream& strm, const Printable<git_index_time>& p) {
  strm << p.value.seconds << '.' << std::setw(9) << std::setfill('0') << p.value.nanoseconds;
  return strm;
}

}  // namespace gitstatus

#endif  // ROMKATV_GITSTATUS_PRINT_H_
