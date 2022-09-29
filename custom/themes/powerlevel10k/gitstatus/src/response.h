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

#ifndef ROMKATV_GITSTATUS_RESPONSE_H_
#define ROMKATV_GITSTATUS_RESPONSE_H_

#include <cstddef>
#include <cstdint>
#include <sstream>
#include <string>

#include "string_view.h"

namespace gitstatus {

class ResponseWriter {
 public:
  ResponseWriter(std::string request_id);
  ResponseWriter(ResponseWriter&&) = delete;
  ~ResponseWriter();

  void Print(ssize_t val);
  void Print(StringView val);
  void Print(const char* val) { Print(StringView(val)); }

  void Dump(const char* log);

 private:
  bool done_ = false;
  std::string request_id_;
  std::ostringstream strm_;
};

}  // namespace gitstatus

#endif  // ROMKATV_GITSTATUS_RESPONSE_H_
