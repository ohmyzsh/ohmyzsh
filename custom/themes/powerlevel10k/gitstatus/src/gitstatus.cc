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

#include <time.h>

#include <cstddef>
#include <future>
#include <string>

#include <git2.h>

#include "check.h"
#include "git.h"
#include "logging.h"
#include "options.h"
#include "print.h"
#include "repo.h"
#include "repo_cache.h"
#include "request.h"
#include "response.h"
#include "scope_guard.h"
#include "thread_pool.h"
#include "timer.h"

namespace gitstatus {
namespace {

using namespace std::string_literals;

void Truncate(std::string& s, size_t max_len) {
  if (s.size() > max_len) s.resize(max_len);
}

void ProcessRequest(const Options& opts, RepoCache& cache, Request req) {
  Timer timer;
  ON_SCOPE_EXIT(&) { timer.Report("request"); };

  ResponseWriter resp(req.id);
  Repo* repo = cache.Open(req.dir, req.from_dotgit);
  if (!repo) return;

  git_config* cfg;
  VERIFY(!git_repository_config(&cfg, repo->repo())) << GitError();
  ON_SCOPE_EXIT(=) { git_config_free(cfg); };
  VERIFY(!git_config_refresh(cfg)) << GitError();

  // Symbolic reference if and only if the repo is empty.
  git_reference* head = Head(repo->repo());
  if (!head) return;
  ON_SCOPE_EXIT(=) { git_reference_free(head); };

  // Null if and only if the repo is empty.
  const git_oid* head_target = git_reference_target(head);

  // Looking up tags may take some time. Do it in the background while we check for stuff.
  // Note that GetTagName() doesn't access index, so it'll overlap with index reading and
  // parsing.
  std::future<std::string> tag = repo->GetTagName(head_target);
  ON_SCOPE_EXIT(&) {
    if (tag.valid()) {
      try {
        tag.wait();
      } catch (const Exception&) {
      }
    }
  };

  // Repository working directory. Absolute; no trailing slash. E.g., "/home/romka/gitstatus".
  StringView workdir(git_repository_workdir(repo->repo()));
  if (workdir.len == 0) return;
  if (workdir.len > 1 && workdir.ptr[workdir.len - 1] == '/') --workdir.len;
  resp.Print(workdir);

  // Revision. Either 40 hex digits or an empty string for empty repo.
  resp.Print(head_target ? git_oid_tostr_s(head_target) : "");

  // Local branch name (e.g., "master") or empty string if not on a branch.
  resp.Print(LocalBranchName(head));

  // Remote tracking branch or null.
  RemotePtr remote = GetRemote(repo->repo(), head);

  // Tracking remote branch name (e.g., "master") or empty string if there is no tracking remote.
  resp.Print(remote ? remote->branch : "");

  // Tracking remote name (e.g., "origin") or empty string if there is no tracking remote.
  resp.Print(remote ? remote->name : "");

  // Tracking remote URL or empty string if there is no tracking remote.
  resp.Print(remote ? remote->url : "");

  // Repository state, A.K.A. action. For example, "merge".
  resp.Print(RepoState(repo->repo()));

  IndexStats stats;
  // Look for staged, unstaged and untracked. This is where most of the time is spent.
  if (req.diff) stats = repo->GetIndexStats(head_target, cfg);

  // The number of files in the index.
  resp.Print(stats.index_size);
  // The number of staged changes. At most opts.max_num_staged.
  resp.Print(stats.num_staged);
  // The number of unstaged changes. At most opts.max_num_unstaged. 0 if index is too large.
  resp.Print(stats.num_unstaged);
  // The number of conflicted changes. At most opts.max_num_conflicted. 0 if index is too large.
  resp.Print(stats.num_conflicted);
  // The number of untracked changes. At most opts.max_num_untracked. 0 if index is too large.
  resp.Print(stats.num_untracked);

  if (remote && remote->ref) {
    const char* ref = git_reference_name(remote->ref);
    // Number of commits we are ahead of upstream. Non-negative integer.
    resp.Print(CountRange(repo->repo(), ref + "..HEAD"s));
    // Number of commits we are behind upstream. Non-negative integer.
    resp.Print(CountRange(repo->repo(), "HEAD.."s + ref));
  } else {
    resp.Print("0");
    resp.Print("0");
  }

  // Number of stashes. Non-negative integer.
  resp.Print(NumStashes(repo->repo()));

  // Tag that points to HEAD (e.g., "v4.2") or empty string if there aren't any. The same as
  // `git describe --tags --exact-match`.
  resp.Print(tag.get());

  // The number of unstaged deleted files. At most stats.num_unstaged.
  resp.Print(stats.num_unstaged_deleted);
  // The number of staged new files. At most stats.num_staged.
  resp.Print(stats.num_staged_new);
  // The number of staged deleted files. At most stats.num_staged.
  resp.Print(stats.num_staged_deleted);

  // Push remote or null.
  PushRemotePtr push_remote = GetPushRemote(repo->repo(), head);

  // Push remote name (e.g., "origin") or empty string if there is no push remote.
  resp.Print(push_remote ? push_remote->name : "");

  // Push remote URL or empty string if there is no push remote.
  resp.Print(push_remote ? push_remote->url : "");

  if (push_remote && push_remote->ref) {
    const char* ref = git_reference_name(push_remote->ref);
    // Number of commits we are ahead of push remote. Non-negative integer.
    resp.Print(CountRange(repo->repo(), ref + "..HEAD"s));
    // Number of commits we are behind upstream. Non-negative integer.
    resp.Print(CountRange(repo->repo(), "HEAD.."s + ref));
  } else {
    resp.Print("0");
    resp.Print("0");
  }

  // The number of files in the index with skip-worktree bit set.
  resp.Print(stats.num_skip_worktree);
  // The number of files in the index with assume-unchanged bit set.
  resp.Print(stats.num_assume_unchanged);

  CommitMessage msg = head_target ? GetCommitMessage(repo->repo(), *head_target) : CommitMessage();
  Truncate(msg.summary, opts.max_commit_summary_length);
  resp.Print(msg.encoding);
  resp.Print(msg.summary);

  resp.Dump("with git status");
}

int GitStatus(int argc, char** argv) {
  tzset();
  Options opts = ParseOptions(argc, argv);
  g_min_log_level = opts.log_level;
  for (int i = 0; i != argc; ++i) LOG(INFO) << "argv[" << i << "]: " << Print(argv[i]);
  RequestReader reader(fileno(stdin), opts.lock_fd, opts.parent_pid);
  RepoCache cache(opts);

  InitGlobalThreadPool(opts.num_threads);
  git_libgit2_opts(GIT_OPT_ENABLE_STRICT_HASH_VERIFICATION, 0);
  git_libgit2_opts(GIT_OPT_DISABLE_INDEX_CHECKSUM_VERIFICATION, 1);
  git_libgit2_opts(GIT_OPT_DISABLE_INDEX_FILEPATH_VALIDATION, 1);
  git_libgit2_opts(GIT_OPT_DISABLE_READNG_PACKED_TAGS, 1);
  git_libgit2_init();

  while (true) {
    try {
      Request req;
      if (reader.ReadRequest(req)) {
        LOG(INFO) << "Processing request: " << req;
        try {
          ProcessRequest(opts, cache, req);
          LOG(INFO) << "Successfully processed request: " << req;
        } catch (const Exception&) {
          LOG(ERROR) << "Error processing request: " << req;
        }
      } else if (opts.repo_ttl >= Duration()) {
        cache.Free(Clock::now() - opts.repo_ttl);
      }
    } catch (const Exception&) {
    }
  }
}

}  // namespace
}  // namespace gitstatus

int main(int argc, char** argv) { gitstatus::GitStatus(argc, argv); }
