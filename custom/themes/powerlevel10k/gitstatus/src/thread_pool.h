#ifndef ROMKATV_GITSTATUS_THREAD_POOL_H_
#define ROMKATV_GITSTATUS_THREAD_POOL_H_

#include <condition_variable>
#include <cstddef>
#include <cstdint>
#include <functional>
#include <mutex>
#include <queue>
#include <thread>
#include <tuple>
#include <utility>

#include "time.h"

namespace gitstatus {

class ThreadPool {
 public:
  explicit ThreadPool(size_t num_threads);
  ThreadPool(ThreadPool&&) = delete;

  // Waits for the currently running functions to finish.
  // Does NOT wait for the queue of functions to drain.
  // If you want the latter, call Wait() manually.
  ~ThreadPool();

  // Runs `f` on one of the threads at or after time `t`. Can be called
  // from any thread. Can be called concurrently.
  //
  // Does not block.
  void Schedule(Time t, std::function<void()> f);

  void Schedule(std::function<void()> f) { Schedule(Clock::now(), std::move(f)); }

  // Blocks until the work queue is empty and there are no currently
  // running functions.
  void Wait();

  size_t num_threads() const { return threads_.size(); }

 private:
  struct Work {
    bool operator<(const Work& w) const { return std::tie(w.t, w.idx) < std::tie(t, idx); }
    Time t;
    int64_t idx;
    mutable std::function<void()> f;
  };

  void Loop(size_t tid);

  int64_t last_idx_ = 0;
  int64_t num_inflight_;
  bool exit_ = false;
  // Do we have a thread waiting on sleeper_cv_?
  bool have_sleeper_ = false;
  std::mutex mutex_;
  // Any number of threads can wait on this condvar. Always without a timeout.
  std::condition_variable cv_;
  // At most one thread can wait on this condvar at a time. Always with a timeout.
  std::condition_variable sleeper_cv_;
  // Signalled when the work queue is empty and there is nothing inflight.
  std::condition_variable idle_cv_;
  std::priority_queue<Work> work_;
  std::vector<std::thread> threads_;
};

void InitGlobalThreadPool(size_t num_threads);

ThreadPool* GlobalThreadPool();

}  // namespace gitstatus

#endif  // ROMKATV_GITSTATUS_THREAD_POOL_H_
