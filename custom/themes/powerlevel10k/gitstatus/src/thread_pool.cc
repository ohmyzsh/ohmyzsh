#include "thread_pool.h"

#include <cassert>
#include <utility>

#include "check.h"
#include "logging.h"

namespace gitstatus {

ThreadPool::ThreadPool(size_t num_threads) : num_inflight_(num_threads) {
  for (size_t i = 0; i != num_threads; ++i) {
    threads_.emplace_back([=]() { Loop(i + 1); });
  }
}

ThreadPool::~ThreadPool() {
  {
    std::lock_guard<std::mutex> lock(mutex_);
    exit_ = true;
  }
  cv_.notify_all();
  sleeper_cv_.notify_one();
  for (std::thread& t : threads_) t.join();
}

void ThreadPool::Schedule(Time t, std::function<void()> f) {
  std::condition_variable* wake = nullptr;
  {
    std::unique_lock<std::mutex> lock(mutex_);
    work_.push(Work{std::move(t), ++last_idx_, std::move(f)});
    if (work_.top().idx == last_idx_) wake = have_sleeper_ ? &sleeper_cv_ : &cv_;
  }
  if (wake) wake->notify_one();
}

void ThreadPool::Loop(size_t tid) {
  auto Next = [&]() -> std::function<void()> {
    std::unique_lock<std::mutex> lock(mutex_);
    --num_inflight_;
    if (work_.empty() && num_inflight_ == 0) idle_cv_.notify_all();
    while (true) {
      if (exit_) return nullptr;
      if (work_.empty()) {
        cv_.wait(lock);
        continue;
      }
      Time now = Clock::now();
      const Work& top = work_.top();
      if (top.t <= now) {
        std::function<void()> res = std::move(top.f);
        work_.pop();
        ++num_inflight_;
        bool notify = !work_.empty() && !have_sleeper_;
        lock.unlock();
        if (notify) cv_.notify_one();
        return res;
      }
      if (have_sleeper_) {
        cv_.wait(lock);
        continue;
      }
      have_sleeper_ = true;
      sleeper_cv_.wait_until(lock, top.t);
      assert(have_sleeper_);
      have_sleeper_ = false;
    }
  };
  while (std::function<void()> f = Next()) f();
}

void ThreadPool::Wait() {
  std::unique_lock<std::mutex> lock(mutex_);
  idle_cv_.wait(lock, [&] { return work_.empty() && num_inflight_ == 0; });
}

static ThreadPool* g_thread_pool = nullptr;

void InitGlobalThreadPool(size_t num_threads) {
  CHECK(!g_thread_pool);
  LOG(INFO) << "Spawning " << num_threads << " thread(s)";
  g_thread_pool = new ThreadPool(num_threads);
}

ThreadPool* GlobalThreadPool() { return g_thread_pool; }

}  // namespace gitstatus
