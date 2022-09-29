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

#ifndef ROMKATV_GITSTATUS_ARENA_H_
#define ROMKATV_GITSTATUS_ARENA_H_

#include <cassert>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <limits>
#include <new>
#include <type_traits>
#include <vector>

#include "string_view.h"

namespace gitstatus {

// Thread-compatible. Very fast and very flexible w.r.t. allocation size and alignment.
//
// Natural API extensions:
//
//   // Donates a block to the arena. When the time comes, it'll be freed with
//   // free(p, size, userdata).
//   void Donate(void* p, size_t size, void* userdata, void(*free)(void*, size_t, void*));
class Arena {
 public:
  struct Options {
    // The first call to Allocate() will allocate a block of this size. There is one exception when
    // the first requested allocation size is larger than this limit. Subsequent blocks will be
    // twice as large as the last until they saturate at max_block_size.
    size_t min_block_size = 64;

    // Allocate blocks at most this large. There is one exception when the requested allocation
    // size is larger than this limit.
    size_t max_block_size = 8 << 10;

    // When the size of the first allocation in a block is larger than this threshold, the block
    // size will be equal to the allocation size. This is meant to reduce memory waste when making
    // many allocations with sizes slightly over max_block_size / 2. With max_alloc_threshold equal
    // to max_block_size / N, the upper bound on wasted memory when making many equally-sized
    // allocations is 100.0 / (N + 1) percent. When making allocations of different sizes, the upper
    // bound on wasted memory is 50%.
    size_t max_alloc_threshold = 1 << 10;

    // Natural extensions:
    //
    //   void* userdata;
    //   void (*alloc)(size_t size, size_t alignment, void* userdata);
    //   void (*free)(void* p, size_t size, void* userdata);
  };

  // Requires: opt.min_block_size <= opt.max_block_size.
  //
  // Doesn't allocate any memory.
  Arena(Options opt);
  Arena() : Arena(Options()) {}
  Arena(Arena&&);
  ~Arena();

  Arena& operator=(Arena&& other);

  // Requires: alignment is a power of 2.
  //
  // Result is never null and always aligned. If size is zero, the result may be equal to the last.
  // Alignment above alignof(std::max_align_t) is supported. There is no requirement for alignment
  // to be less than size or to divide it.
  inline void* Allocate(size_t size, size_t alignment) {
    assert(alignment && !(alignment & (alignment - 1)));
    uintptr_t p = Align(top_->tip, alignment);
    uintptr_t e = p + size;
    if (e <= top_->end) {
      top_->tip = e;
      return reinterpret_cast<void*>(p);
    }
    return AllocateSlow(size, alignment);
  }

  template <class T>
  inline T* Allocate(size_t n) {
    static_assert(!std::is_reference<T>(), "");
    return static_cast<T*>(Allocate(n * sizeof(T), alignof(T)));
  }

  template <class T>
  inline T* Allocate() {
    return Allocate<T>(1);
  }

  inline char* MemDup(const char* p, size_t len) {
    char* res = Allocate<char>(len);
    std::memcpy(res, p, len);
    return res;
  }

  // Copies the null-terminated string (including the trailing null character) to the arena and
  // returns a pointer to the copy.
  inline char* StrDup(const char* s) {
    size_t len = std::strlen(s);
    return MemDup(s, len + 1);
  }

  // Guarantees: !StrDup(p, len)[len].
  inline char* StrDup(const char* p, size_t len) {
    char* res = Allocate<char>(len + 1);
    std::memcpy(res, p, len);
    res[len] = 0;
    return res;
  }

  // Guarantees: !StrDup(s)[s.len].
  inline char* StrDup(StringView s) {
    return StrDup(s.ptr, s.len);
  }

  template <class... Ts>
  inline char* StrCat(const Ts&... ts) {
    return [&](std::initializer_list<StringView> ss) {
      size_t len = 0;
      for (StringView s : ss) len += s.len;
      char* p = Allocate<char>(len + 1);
      for (StringView s : ss) {
        std::memcpy(p, s.ptr, s.len);
        p += s.len;
      }
      *p = 0;
      return p - len;
    }({ts...});
  }

  // Copies/moves `val` to the arena and returns a pointer to it.
  template <class T>
  inline std::remove_const_t<std::remove_reference_t<T>>* Dup(T&& val) {
    return DirectInit<std::remove_const_t<std::remove_reference_t<T>>>(std::forward<T>(val));
  }

  // The same as `new T{args...}` but on the arena.
  template <class T, class... Args>
  inline T* DirectInit(Args&&... args) {
    T* res = Allocate<T>();
    ::new (const_cast<void*>(static_cast<const void*>(res))) T(std::forward<Args>(args)...);
    return res;
  }

  // The same as `new T(args...)` but on the arena.
  template <class T, class... Args>
  inline T* BraceInit(Args&&... args) {
    T* res = Allocate<T>();
    ::new (const_cast<void*>(static_cast<const void*>(res))) T{std::forward<Args>(args)...};
    return res;
  }

  // Tip() and TipSize() allow you to allocate the remainder of the current block. They can be
  // useful if you are flexible w.r.t. the allocation size.
  //
  // Invariant:
  //
  //   const void* tip = Tip();
  //   void* p = Allocate(TipSize(), 1);  // grab the remainder of the current block
  //   assert(p == tip);
  const void* Tip() const { return reinterpret_cast<const void*>(top_->tip); }
  size_t TipSize() const { return top_->end - top_->tip; }

  // Invalidates all allocations (without running destructors of allocated objects) and frees all
  // blocks except at most the specified number of blocks. The retained blocks will be used to
  // fulfil future allocation requests.
  void Reuse(size_t num_blocks = std::numeric_limits<size_t>::max());

 private:
  struct Block {
    size_t size() const { return end - start; }
    uintptr_t start;
    uintptr_t tip;
    uintptr_t end;
  };

  inline static size_t Align(size_t n, size_t m) { return (n + m - 1) & ~(m - 1); };

  void AddBlock(size_t size, size_t alignment);
  bool ReuseBlock(size_t size, size_t alignment);

  __attribute__((noinline)) void* AllocateSlow(size_t size, size_t alignment);

  Options opt_;
  std::vector<Block> blocks_;
  // Invariant: !blocks_.empty() <= reusable_ && reusable_ <= blocks_.size().
  size_t reusable_ = 0;
  // Invariant: (top_ == &g_empty_block) == blocks_.empty().
  // Invariant: blocks_.empty() || top_ == &blocks_.back() || top_ < blocks_.data() + reusable_.
  Block* top_;

  static Block g_empty_block;
};

// Copies of ArenaAllocator use the same thread-compatible Arena without synchronization.
template <class T>
class ArenaAllocator {
 public:
  using value_type = T;
  using pointer = T*;
  using const_pointer = const T*;
  using reference = T&;
  using const_reference = const T&;
  using size_type = size_t;
  using difference_type = ptrdiff_t;
  using propagate_on_container_move_assignment = std::true_type;
  template <class U>
  struct rebind {
    using other = ArenaAllocator<U>;
  };
  using is_always_equal = std::false_type;

  ArenaAllocator(Arena* arena = nullptr) : arena_(*arena) {}

  Arena& arena() const { return arena_; }

  pointer address(reference x) const { return &x; }
  const_pointer address(const_reference x) const { return &x; }
  pointer allocate(size_type n, const void* hint = nullptr) { return arena_.Allocate<T>(n); }
  void deallocate(T* p, std::size_t n) {}
  size_type max_size() const { return std::numeric_limits<size_type>::max() / sizeof(value_type); }

  template <class U, class... Args>
  void construct(U* p, Args&&... args) {
    ::new (const_cast<void*>(static_cast<const void*>(p))) U(std::forward<Args>(args)...);
  }

  template <class U>
  void destroy(U* p) {
    p->~U();
  }

  bool operator==(const ArenaAllocator& other) const { return &arena_ == &other.arena_; }
  bool operator!=(const ArenaAllocator& other) const { return &arena_ != &other.arena_; }

 private:
  Arena& arena_;
};

template <class C>
struct LazyWithArena;

template <template <class, class> class C, class T1, class A>
struct LazyWithArena<C<T1, A>> {
  using type = C<T1, ArenaAllocator<typename C<T1, A>::value_type>>;
};

template <template <class, class, class> class C, class T1, class T2, class A>
struct LazyWithArena<C<T1, T2, A>> {
  using type = C<T1, T2, ArenaAllocator<typename C<T1, T2, A>::value_type>>;
};

template <class C>
using WithArena = typename LazyWithArena<C>::type;

}  // namespace gitstatus

#endif  // ROMKATV_GITSTATUS_DIR_H_
