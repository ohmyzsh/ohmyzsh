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

#include "response.h"

#include <cctype>
#include <cstring>
#include <iostream>

#include "check.h"
#include "serialization.h"

namespace gitstatus {

namespace {

constexpr char kUnreadable = '?';

void SafePrint(std::ostream& strm, StringView s) {
  for (size_t i = 0; i != s.len; ++i) {
    char c = s.ptr[i];
    strm << (c > 127 || std::isprint(c) ? c : kUnreadable);
  }
}

}  // namespace

ResponseWriter::ResponseWriter(std::string request_id) : request_id_(std::move(request_id)) {
  SafePrint(strm_, request_id_);
  Print(1);
}

ResponseWriter::~ResponseWriter() {
  if (!done_) {
    strm_.str("");
    SafePrint(strm_, request_id_);
    Print("0");
    Dump("without git status");
  }
}

void ResponseWriter::Print(ssize_t val) {
  strm_ << kFieldSep;
  strm_ << val;
}

void ResponseWriter::Print(StringView val) {
  strm_ << kFieldSep;
  SafePrint(strm_, val);
}

void ResponseWriter::Dump(const char* log) {
  CHECK(!done_);
  done_ = true;
  LOG(INFO) << "Replying " << log;
  std::cout << strm_.str() << kMsgSep << std::flush;
}

}  // namespace gitstatus
