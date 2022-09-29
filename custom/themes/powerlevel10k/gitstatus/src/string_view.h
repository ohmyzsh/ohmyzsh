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

#ifndef ROMKATV_GITSTATUS_STRING_VIEW_H_
#define ROMKATV_GITSTATUS_STRING_VIEW_H_

#include <algorithm>
#include <cstddef>
#include <cstring>
#include <ostream>
#include <string>

namespace gitstatus {

// WARNING: StringView must not have embedded null characters. Violations cause UB.
struct StringView {
  StringView() : StringView("") {}

  // Requires: !memchr(s.data(), 0, s.size()).
  //
  // WARNING: The existence of this requirement and the fact that this constructor is implicit
  // means it's dangerous to have std::string instances with embedded null characters anywhere
  // in the program. If you have an std::string `s` with embedded nulls, an innocent-looking
  // `F(s)` might perform an implicit conversion to StringView and land you squarely in the
  // Undefined Behavior land.
  StringView(const std::string& s) : StringView(s.c_str(), s.size()) {}

  // Requires: !memchr(ptr, 0, len).
  StringView(const char* ptr, size_t len) : ptr(ptr), len(len) {}

  // Requires: end >= begin && !memchr(begin, 0, end - begin).
  StringView(const char* begin, const char* end) : StringView(begin, end - begin) {}

  // Requires: strchr(s, 0) == s + N.
  template <size_t N>
  StringView(const char (&s)[N]) : StringView(s, N - 1) {
    static_assert(N, "");
  }

  // Explicit because it's the only constructor that isn't O(1).
  // Are you sure you don't already known the strings's length?
  explicit StringView(const char* ptr) : StringView(ptr, ptr ? std::strlen(ptr) : 0) {}

  bool StartsWith(StringView prefix) const {
    return len >= prefix.len && !std::memcmp(ptr, prefix.ptr, prefix.len);
  }

  bool EndsWith(StringView suffix) const {
    return len >= suffix.len && !std::memcmp(ptr + (len - suffix.len), suffix.ptr, suffix.len);
  }

  const char* ptr;
  size_t len;
};

inline std::ostream& operator<<(std::ostream& strm, StringView s) {
  if (s.ptr) strm.write(s.ptr, s.len);
  return strm;
}

}  // namespace gitstatus

#endif  // ROMKATV_GITSTATUS_STRING_VIEW_H_
