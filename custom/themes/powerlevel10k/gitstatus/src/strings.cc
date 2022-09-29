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

#include <cassert>

#include "strings.h"

namespace gitstatus {

void CEscape(std::ostream& strm, const char* begin, const char* end) {
  assert(!begin == !end);
  if (!begin) return;
  for (; begin != end; ++begin) {
    const unsigned char c = *begin;
    switch (c) {
      case '\t':
        strm << "\\t";
        continue;
      case '\n':
        strm << "\\n";
        continue;
      case '\r':
        strm << "\\r";
        continue;
      case '"':
        strm << "\\\"";
        continue;
      case '\'':
        strm << "\\'";
        continue;
      case '\\':
        strm << "\\\\";
        continue;
    }
    if (c > 31 && c < 127) {
      strm << c;
      continue;
    }
    strm << '\\';
    strm << static_cast<char>('0' + ((c >> 6) & 7));
    strm << static_cast<char>('0' + ((c >> 3) & 7));
    strm << static_cast<char>('0' + ((c >> 0) & 7));
  }
}

void Quote(std::ostream& strm, const char* begin, const char* end) {
  assert(!begin == !end);
  if (!begin) {
    strm << "null";
    return;
  }
  strm << '"';
  CEscape(strm, begin, end);
  strm << '"';
}

}  // namespace gitstatus
