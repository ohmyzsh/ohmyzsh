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

#ifndef ROMKATV_GITSTATUS_ALGORITHM_H_
#define ROMKATV_GITSTATUS_ALGORITHM_H_

#include <algorithm>

namespace gitstatus {

// Requires: Iter is a BidirectionalIterator.
//
// Returns iterator pointing to the last value in [begin, end) that compares equal to the value, or
// begin if none compare equal.
template <class Iter, class T>
Iter FindLast(Iter begin, Iter end, const T& val) {
  while (begin != end && !(*--end == val)) {}
  return end;
}

}  // namespace gitstatus

#endif  // ROMKATV_GITSTATUS_ALGORITHM_H_
