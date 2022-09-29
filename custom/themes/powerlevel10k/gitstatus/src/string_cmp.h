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

#ifndef ROMKATV_GITSTATUS_STRING_CMP_H_
#define ROMKATV_GITSTATUS_STRING_CMP_H_

#include <string.h>  // because there is no std::strcasecmp in C++

#include <algorithm>
#include <cctype>
#include <cstddef>
#include <cstring>

#include "string_view.h"

namespace gitstatus {

// WARNING: These routines assume no embedded null characters in StringView. Violations cause UB.

template <int kCaseSensitive = -1>
struct StrCmp;

template <>
struct StrCmp<0> {
  int operator()(StringView x, StringView y) const {
    size_t n = std::min(x.len, y.len);
    int cmp = strncasecmp(x.ptr, y.ptr, n);
    if (cmp) return cmp;
    return static_cast<ssize_t>(x.len) - static_cast<ssize_t>(y.len);
  }

  int operator()(StringView x, const char* y) const {
    for (const char *p = x.ptr, *e = p + x.len; p != e; ++p, ++y) {
      if (int cmp = std::tolower(*p) - std::tolower(*y)) return cmp;
    }
    return 0 - *y;
  }

  int operator()(char x, char y) const { return std::tolower(x) - std::tolower(y); }
  int operator()(const char* x, const char* y) const { return strcasecmp(x, y); }
  int operator()(const char* x, StringView y) const { return -operator()(y, x); }
};

template <>
struct StrCmp<1> {
  int operator()(StringView x, StringView y) const {
    size_t n = std::min(x.len, y.len);
    int cmp = std::memcmp(x.ptr, y.ptr, n);
    if (cmp) return cmp;
    return static_cast<ssize_t>(x.len) - static_cast<ssize_t>(y.len);
  }

  int operator()(StringView x, const char* y) const {
    for (const char *p = x.ptr, *e = p + x.len; p != e; ++p, ++y) {
      if (int cmp = *p - *y) return cmp;
    }
    return 0 - *y;
  }

  int operator()(char x, char y) const { return x - y; }
  int operator()(const char* x, const char* y) const { return std::strcmp(x, y); }
  int operator()(const char* x, StringView y) const { return -operator()(y, x); }
};

template <>
struct StrCmp<-1> {
  explicit StrCmp(bool case_sensitive) : case_sensitive(case_sensitive) {}

  template <class X, class Y>
  int operator()(const X& x, const Y& y) const {
    return case_sensitive ? StrCmp<1>()(x, y) : StrCmp<0>()(x, y);
  }

  bool case_sensitive;
};

template <int kCaseSensitive = -1>
struct StrLt : private StrCmp<kCaseSensitive> {
  using StrCmp<kCaseSensitive>::StrCmp;

  template <class X, class Y>
  bool operator()(const X& x, const Y& y) const {
    return StrCmp<kCaseSensitive>::operator()(x, y) < 0;
  }
};

template <int kCaseSensitive = -1>
struct StrEq : private StrCmp<kCaseSensitive> {
  using StrCmp<kCaseSensitive>::StrCmp;

  template <class X, class Y>
  bool operator()(const X& x, const Y& y) const {
    return StrCmp<kCaseSensitive>::operator()(x, y) == 0;
  }

  bool operator()(const StringView& x, const StringView& y) const {
    return x.len == y.len && StrCmp<kCaseSensitive>::operator()(x, y) == 0;
  }
};

template <int kCaseSensitive = -1>
struct Str {
  static_assert(kCaseSensitive == 0 || kCaseSensitive == 1, "");

  static const bool case_sensitive = kCaseSensitive;

  StrCmp<kCaseSensitive> Cmp;
  StrLt<kCaseSensitive> Lt;
  StrEq<kCaseSensitive> Eq;
};

template <int kCaseSensitive>
const bool Str<kCaseSensitive>::case_sensitive;

template <>
struct Str<-1> {
  explicit Str(bool case_sensitive)
      : case_sensitive(case_sensitive),
        Cmp(case_sensitive),
        Lt(case_sensitive),
        Eq(case_sensitive) {}

  bool case_sensitive;

  StrCmp<-1> Cmp;
  StrLt<-1> Lt;
  StrEq<-1> Eq;
};

template <class Iter>
void StrSort(Iter begin, Iter end, bool case_sensitive) {
  case_sensitive ? std::sort(begin, end, StrLt<true>()) : std::sort(begin, end, StrLt<false>());
}

}  // namespace gitstatus

#endif  // ROMKATV_GITSTATUS_STRING_CMP_H_
