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

#include "arena.h"

#include <algorithm>
#include <type_traits>

#include "bits.h"
#include "check.h"

namespace gitstatus {

namespace {

size_t Clamp(size_t min, size_t val, size_t max) { return std::min(max, std::max(min, val)); }

static const uintptr_t kSingularity = reinterpret_cast<uintptr_t>(&kSingularity);

}  // namespace

// Triple singularity. We are all fucked.
Arena::Block Arena::g_empty_block = {kSingularity, kSingularity, kSingularity};

Arena::Arena(Arena::Options opt) : opt_(std::move(opt)), top_(&g_empty_block) {
  CHECK(opt_.min_block_size <= opt_.max_block_size);
}

Arena::Arena(Arena&& other) : Arena() { *this = std::move(other); }

Arena::~Arena() {
  // See comments in Makefile for the reason sized deallocation is not used.
  for (const Block& b : blocks_) ::operator delete(reinterpret_cast<void*>(b.start));
}

Arena& Arena::operator=(Arena&& other) {
  if (this != &other) {
    // In case std::vector ever gets small object optimization.
    size_t idx = other.reusable_ ? other.top_ - other.blocks_.data() : 0;
    opt_ = other.opt_;
    blocks_ = std::move(other.blocks_);
    reusable_ = other.reusable_;
    top_ = reusable_ ? blocks_.data() + idx : &g_empty_block;
    other.blocks_.clear();
    other.reusable_ = 0;
    other.top_ = &g_empty_block;
  }
  return *this;
}

void Arena::Reuse(size_t num_blocks) {
  reusable_ = std::min(reusable_, num_blocks);
  for (size_t i = reusable_; i != blocks_.size(); ++i) {
    const Block& b = blocks_[i];
    // See comments in Makefile for the reason sized deallocation is not used.
    ::operator delete(reinterpret_cast<void*>(b.start));
  }
  blocks_.resize(reusable_);
  if (reusable_) {
    top_ = blocks_.data();
    top_->tip = top_->start;
  } else {
    top_ = &g_empty_block;
  }
}

void Arena::AddBlock(size_t size, size_t alignment) {
  if (alignment > alignof(std::max_align_t)) {
    size += alignment - 1;
  } else {
    size = std::max(size, alignment);
  }
  if (size <= top_->size() && top_ < blocks_.data() + reusable_ - 1) {
    assert(blocks_.front().size() == top_->size());
    ++top_;
    top_->tip = top_->start;
    return;
  }
  if (size <= opt_.max_alloc_threshold) {
    size =
        std::max(size, Clamp(opt_.min_block_size, NextPow2(top_->size() + 1), opt_.max_block_size));
  }

  auto p = reinterpret_cast<uintptr_t>(::operator new(size));
  blocks_.push_back(Block{p, p, p + size});
  if (reusable_) {
    if (size < blocks_.front().size()) {
      top_ = &blocks_.back();
      return;
    }
    if (size > blocks_.front().size()) reusable_ = 0;
  }
  std::swap(blocks_.back(), blocks_[reusable_]);
  top_ = &blocks_[reusable_++];
}

void* Arena::AllocateSlow(size_t size, size_t alignment) {
  assert(alignment && !(alignment & (alignment - 1)));
  AddBlock(size, alignment);
  assert(Align(top_->tip, alignment) + size <= top_->end);
  return Allocate(size, alignment);
}

}  // namespace gitstatus
