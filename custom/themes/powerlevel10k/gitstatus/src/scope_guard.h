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

#ifndef ROMKATV_GITSTATUS_SCOPE_GUARD_H_
#define ROMKATV_GITSTATUS_SCOPE_GUARD_H_

#include <utility>

#define ON_SCOPE_EXIT(capture...)                                     \
  auto GITSTATUS_INTERNAL_CAT(_gitstatus_scope_guard_, __COUNTER__) = \
      ::gitstatus::internal_scope_guard::ScopeGuardGenerator() = [capture]()

#define GITSTATUS_INTERNAL_CAT_I(x, y) x##y
#define GITSTATUS_INTERNAL_CAT(x, y) GITSTATUS_INTERNAL_CAT_I(x, y)

namespace gitstatus {
namespace internal_scope_guard {

void Undefined();

template <class F>
class ScopeGuard {
 public:
  explicit ScopeGuard(F f) : f_(std::move(f)) {}
  ~ScopeGuard() { std::move(f_)(); }
  ScopeGuard(ScopeGuard&& other) : f_(std::move(other.f_)) { Undefined(); }

 private:
  F f_;
};

struct ScopeGuardGenerator {
  template <class F>
  ScopeGuard<F> operator=(F f) const {
    return ScopeGuard<F>(std::move(f));
  }
};

}  // namespace internal_scope_guard
}  // namespace gitstatus

#endif  // ROMKATV_GITSTATUS_SCOPE_GUARD_H_
