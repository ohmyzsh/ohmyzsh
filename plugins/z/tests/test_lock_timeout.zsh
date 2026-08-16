# `ZSHZ_LOCK_TIMEOUT' must actually fire and degrade gracefully.
#
# When some other process holds the lockfile, `zshz --add' must give
# up after `ZSHZ_LOCK_TIMEOUT' seconds (default 1) rather than blocking
# the prompt indefinitely. The dropped update is the cost; the prompt
# staying responsive is the benefit. This file pins three properties:
#   1. The call returns within ~1.5s of a 1s timeout.
#   2. It exits non-zero (the user/caller can detect the failure).
#   3. The datafile is unchanged -- no half-write, no rewrite that
#      drops pre-existing entries.

test_lock_timeout_fires_when_lock_held_externally() {
  # We need `zsystem flock' for both the holder and the contender.
  # The plugin loads `zsh/system' itself; if it isn't available, the
  # plugin runs the no-flock path and there's no timeout to test.
  if ! (( ZSHZ[USE_FLOCK] )); then
    print "skip: zsystem flock unavailable"
    return 0
  fi

  mkdir -p "$TESTDIR/target"
  zshz_seed "$TESTDIR/seed" 7 60
  touch "${ZSHZ_DATA}.lock"

  # Spawn an external holder. `zsystem flock' (no -f) acquires the
  # lock on a hidden fd that the shell holds for its lifetime; the
  # `sleep' keeps the holder alive long enough for our contender to
  # hit the timeout. The lock must live in a separate process (POSIX
  # advisory locks are per-process; flock from the runner shell
  # wouldn't contend with itself).
  #
  # Background with `&!' (fork+disown) rather than `&' because zsh
  # 4.3.11's `&'/`wait' machinery segfaults even under light fork
  # load -- cf. test_concurrency.zsh. With `&!' there's no entry to
  # `wait' on; the holder self-terminates when its sleep ends.
  zsh --no-rcs -c "
    zmodload zsh/system
    zsystem flock '${ZSHZ_DATA}.lock'
    sleep 3
  " &!
  local holder=$!

  # Give the holder time to acquire the lock before we start the
  # contender. Without this, `zshz --add' could win the race and the
  # test would test nothing.
  sleep 0.2

  typeset -F SECONDS=0
  ZSHZ_LOCK_TIMEOUT=1 zshz --add "$TESTDIR/target"
  local rc=$?
  local elapsed=$SECONDS

  # Best-effort cleanup so the holder doesn't outlive the test for
  # too long. The holder is already disowned, so no `wait'.
  kill $holder 2>/dev/null

  # 1. Non-zero return.
  assert_ne "0" "$rc" "--add should fail when the lock can't be acquired"

  # 2. Bounded duration. Generous upper bound (3s) to absorb scheduler
  #    jitter in CI; the timeout itself is 1s.
  if (( elapsed > 3 )); then
    fail "--add should give up within ~1s; took ${elapsed}s"
  fi
  # And it shouldn't return *before* the timeout either, which would
  # mean the lock wasn't held when we ran -- our holder lost the race.
  if (( elapsed < 0.5 )); then
    fail "--add returned before the timeout (${elapsed}s); the holder may have lost the race"
  fi

  # 3. Datafile unchanged: target not added, seed entry intact.
  assert_eq "" "$(zshz_rank_of "$TESTDIR/target")" \
    "target should not have been added when lock acquisition failed"
  assert_eq "7" "$(zshz_rank_of "$TESTDIR/seed")" \
    "pre-existing entry should be unchanged after a failed --add"
}

test_lock_timeout_succeeds_when_lock_free() {
  # Control: with no contender, --add should succeed in well under
  # the timeout. Guards against the test above accidentally passing
  # for the wrong reason (e.g. if the timeout assertions were too
  # loose to distinguish failure from success).
  if ! (( ZSHZ[USE_FLOCK] )); then
    print "skip: zsystem flock unavailable"
    return 0
  fi

  mkdir -p "$TESTDIR/target"
  typeset -F SECONDS=0
  ZSHZ_LOCK_TIMEOUT=1 zshz --add "$TESTDIR/target"
  local rc=$? elapsed=$SECONDS

  assert_eq "0" "$rc" "--add should succeed when no one holds the lock"
  assert_eq "1" "$(zshz_rank_of "$TESTDIR/target")" \
    "target should be in the datafile after a successful --add"
  if (( elapsed > 0.5 )); then
    fail "uncontended --add should be fast; took ${elapsed}s"
  fi
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
