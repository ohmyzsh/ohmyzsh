# Regression tests for concurrent --add / -x writes.
#
# Before the fix, the read-modify-write cycle was racy: lines was read before
# the lock was acquired, and the lock was held on $datafile (whose inode is
# replaced via mv) so concurrent writers did not actually serialize.
#
# Each writer is spawned as an independent `zsh -c` process via xargs rather
# than as a backgrounded subshell of the test runner. This exercises the
# plugin's flock-based serialization across real OS processes (closer to real
# usage: multiple terminals, each their own zsh) and avoids zsh 4.3.11's
# `&`/`wait` machinery, which segfaults under even light fork load.
#
# The plugin's default lock timeout (ZSHZ_LOCK_TIMEOUT=1s) is meant to keep
# stuck holders from freezing the prompt; under heavy concurrent load that
# bound is too tight and writers would time out and silently drop updates.
# The tests bump the timeout via env so honest contention isn't mistaken
# for a regression.
#
# `test_concurrent_add_no_lost_updates' below is the fast, CI-bounded
# (n=20) regression gate. Its heavy, tunable, manual counterpart is
# tests/stress.sh, which cranks N/PARALLEL high and can target an
# arbitrary zsh binary. Keep the shared invariant (datafile format,
# rank==N, ZSHZ_LOCK_TIMEOUT) in sync between the two.

test_concurrent_add_no_lost_updates() {
  # Without `zsystem flock', the plugin's no-lock fallback can't
  # serialize cross-process writers -- each one reads its own
  # snapshot and the last `mv' wins. Skip on environments without
  # `zsh/system' (e.g. MobaXterm's Cygwin).
  if ! (( ZSHZ[USE_FLOCK] )); then
    print "skip: zsystem flock unavailable"
    return 0
  fi
  local n=20
  local target="$TESTDIR/target"
  mkdir -p "$target"

  # On platforms with real POSIX locks the first batch yields rank n every
  # run. MSYS2's emulated locks (over a Windows filesystem) very rarely let a
  # writer's acquisition fail under contention, dropping a single update -- a
  # ~3% environmental flake, not a regression. Retry a few times to absorb it:
  # an honest locking regression loses updates on essentially every run and so
  # fails all attempts, while the rare emulation hiccup clears on a re-run.
  # Each attempt starts from an empty datafile so ranks don't accumulate.
  local attempt rank
  for attempt in 1 2 3; do
    : > "$ZSHZ_DATA"
    seq 1 $n | ( xargs_P 4 \
      env ZSHZ_LOCK_TIMEOUT=30 zsh -c \
        "source '$PLUGIN_DIR/zsh-z.plugin.zsh'; zshz --add '$target'" )
    rank=$(zshz_rank_of "$target")
    [[ $rank == $n ]] && return 0
  done

  assert_eq "$n" "$rank" "$n concurrent adds should produce rank $n (after retries)"
}

test_lock_fd_does_not_leak_across_repeated_adds() {
  # zsystem flock -f opens an fd that persists for the shell process's
  # lifetime; without an explicit zsystem flock -u, the fcntl lock stays
  # held until the shell exits. POSIX advisory locks are per-process, so
  # the leaking shell never notices, but peers block on F_SETLKW until
  # ZSHZ_LOCK_TIMEOUT and silently drop their update.
  #
  # This shell is the runner: do two --add calls so any leaked fd would
  # still be held when we spawn the external writer. The external shell
  # uses a tight 1s timeout: if the runner leaked, it would time out and
  # the rank would not land.
  if ! (( ZSHZ[USE_FLOCK] )); then
    print "skip: zsystem flock unavailable"
    return 0
  fi
  local a="$TESTDIR/leak-a" b="$TESTDIR/leak-b" c="$TESTDIR/leak-c"
  mkdir -p "$a" "$b" "$c"
  zshz --add "$a"
  zshz --add "$b"

  local rc
  env ZSHZ_LOCK_TIMEOUT=1 zsh --no-rcs -c "
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    zshz --add '$c'
  " > /dev/null 2>&1
  rc=$?

  assert_eq "0" "$rc" "external --add should not time out waiting on a leaked lock"
  assert_eq "1" "$(zshz_rank_of "$c")" "external --add should have landed in the datafile"
}

test_concurrent_add_two_paths_each_independent() {
  if ! (( ZSHZ[USE_FLOCK] )); then
    print "skip: zsystem flock unavailable"
    return 0
  fi
  local n=15 i
  local a="$TESTDIR/a" b="$TESTDIR/b"
  mkdir -p "$a" "$b"

  # Absorb the same MSYS2 emulated-lock flake as
  # `test_concurrent_add_no_lost_updates' above, the same way and for the same
  # reason: under contention a writer's acquisition very rarely fails there and
  # a single update is dropped. This test spawns 30 writers to that test's 20,
  # so it is if anything likelier to hit it -- as it did, losing one add to `b'
  # on MSYS2 CI while the identical tree passed in a run two seconds later. An
  # honest serialization regression loses updates on essentially every run and
  # so fails all three attempts; the emulation hiccup clears on a re-run. Each
  # attempt starts from an empty datafile so ranks don't accumulate.
  local attempt rank_a rank_b
  for attempt in 1 2 3; do
    : > "$ZSHZ_DATA"
    # Interleave a and b on the input list so xargs runs adds for both paths
    # concurrently (rather than draining one before starting the other).
    {
      for ((i=1; i<=n; i++)); do
        print -- "$a"
        print -- "$b"
      done
    } | ( xargs_P 4 \
          env ZSHZ_LOCK_TIMEOUT=30 zsh -c \
            "source '$PLUGIN_DIR/zsh-z.plugin.zsh'; zshz --add '{}'" )
    rank_a=$(zshz_rank_of "$a")
    rank_b=$(zshz_rank_of "$b")
    [[ $rank_a == $n && $rank_b == $n ]] && return 0
  done

  assert_eq "$n" "$rank_a" "$n concurrent adds to a (after retries)"
  assert_eq "$n" "$rank_b" "$n concurrent adds to b (after retries)"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
