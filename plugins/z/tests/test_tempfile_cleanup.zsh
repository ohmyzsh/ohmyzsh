# `_zshz_add_or_remove_path' must not leave behind `${datafile}.NNNNN'
# tempfiles after a write failure or under normal operation.
#
# The plugin uses `${datafile}.${RANDOM}' as a per-write tempfile and
# atomically `mv's it over the datafile. There are several failure
# paths -- the rewrite can fail at write, at chown, or at mv -- and
# each must `rm -f' the tempfile before returning.
#
# `test_concurrent_mixed.zsh' already pins the no-tempfile-after-
# concurrent-ops invariant for the mixed-add/-x case. This file
# pins the single-process failure paths.
#
# A few scenarios are intentionally *not* covered:
#   - Read-only datafile parent dir: tempfile creation itself fails
#     (no tempfile to leak), but the mkdir/touch in `[[ -f $datafile ]]
#     || touch ...' also writes to stderr ahead of `_zshz_add_or_remove_path'.
#   - SIGKILL mid-write: unavoidable leak; no shell-level handler can
#     run after SIGKILL. The plugin doesn't trap signals, so SIGTERM
#     mid-write also leaks. This is a separate "would be nice" item
#     rather than a contract we currently enforce.

# Glob a directory for `${datafile}.<digits>' tempfiles. Returns 0 if
# none exist.
_no_tempfile_in() {
  local dir=$1 base=${ZSHZ_DATA:t}
  local -a leftovers
  leftovers=( "$dir"/${base}.<->(N) )
  (( ${#leftovers} == 0 )) || \
    fail "tempfile(s) leftover: ${(j:, :)leftovers}"
}

# Fail the first `_mv_failures' renames, then delegate to the real mv.
# The counters are local to the calling test and visible here through Zsh's
# dynamic scoping.
_mv_fail_n_times() {
  (( ++_mv_attempts ))
  (( _mv_attempts <= _mv_failures )) && return 23
  command mv "$@"
}

_test_retry_with_inherited_error_option() {
  setopt LOCAL_OPTIONS "$1"
  integer _mv_attempts=0 _mv_failures=1 _delay_attempts=0

  mkdir -p "$TESTDIR/p"
  ZSHZ[USE_FLOCK]=0
  ZSHZ[MV]=_mv_fail_n_times
  ZSHZ[MV_RETRIES]=1
  ZSHZ[MV_RETRY_DELAY]=1
  # A timeout-like nonzero delay status must not activate the caller's error
  # option and abort before the next rename attempt.
  functions[zselect]='(( ++_delay_attempts )); return 1'

  # This must be a bare call: wrapping it in `if' would suppress the inherited
  # error option throughout zshz() and fail to reproduce the regression.
  zshz --add "$TESTDIR/p"

  assert_eq "2" "$_mv_attempts" \
    "a transient rename failure should be retried"
  assert_eq "1" "$_delay_attempts" \
    "one delay should occur between two rename attempts"
  assert_ne "" "$(zshz_rank_of "$TESTDIR/p")" \
    "the retried update should reach the datafile"
  _no_tempfile_in "$TESTDIR"
}

test_no_tempfile_after_normal_add() {
  mkdir -p "$TESTDIR/p"
  zshz --add "$TESTDIR/p"
  _no_tempfile_in "$TESTDIR"
}

test_no_tempfile_after_many_sequential_adds() {
  # Guards against a bug where each `--add' leaks one tempfile, which
  # would surface as accumulation rather than a single leftover.
  local i
  for ((i=0; i<20; i++)); do
    mkdir -p "$TESTDIR/p_$i"
    zshz --add "$TESTDIR/p_$i"
  done
  _no_tempfile_in "$TESTDIR"
}

test_no_tempfile_after_mv_failure() {
  # Mock `${ZSHZ[MV]}' with `false' so the rename step always fails.
  # The plugin's failure path (`(( write_ret != 0 )) && rm -f tempfile')
  # must clean up the tempfile it just wrote.
  mkdir -p "$TESTDIR/p"
  zshz_seed "$TESTDIR/seed" 5 60   # pre-existing entry to verify it survives
  ZSHZ[MV]=false
  zshz --add "$TESTDIR/p"
  ZSHZ[MV]=mv   # restore for later tests in the same runner

  _no_tempfile_in "$TESTDIR"
  # Datafile content should be unchanged because the mv never landed.
  assert_eq "5" "$(zshz_rank_of "$TESTDIR/seed")" \
    "pre-existing entry should be unchanged when mv fails"
  assert_eq "" "$(zshz_rank_of "$TESTDIR/p")" \
    "new entry should not appear when the rename failed"
}

test_mv_retry_with_inherited_err_return() {
  _test_retry_with_inherited_error_option ERR_RETURN
}

test_mv_retry_with_inherited_err_exit() {
  _test_retry_with_inherited_error_option ERR_EXIT
}

test_mv_retry_transient_failure_succeeds_without_flock() {
  integer _mv_attempts=0 _mv_failures=2 _delay_attempts=0

  mkdir -p "$TESTDIR/p"
  ZSHZ[USE_FLOCK]=0
  ZSHZ[MV]=_mv_fail_n_times
  ZSHZ[MV_RETRIES]=4
  ZSHZ[MV_RETRY_DELAY]=1
  functions[zselect]='(( ++_delay_attempts )); return 1'

  zshz --add "$TESTDIR/p"

  assert_eq "3" "$_mv_attempts" \
    "two transient failures should require three rename attempts"
  assert_eq "2" "$_delay_attempts" \
    "each transient failure should be followed by one delay"
  assert_ne "" "$(zshz_rank_of "$TESTDIR/p")" \
    "the update should land after transient rename failures"
  _no_tempfile_in "$TESTDIR"
}

test_mv_retry_exhaustion_resets_budget_without_flock() {
  integer _mv_attempts=0 _mv_failures=99 _delay_attempts=0
  local before first_rc second_rc

  mkdir -p "$TESTDIR/p"
  zshz_seed "$TESTDIR/seed" 5 60
  before=$(zshz_dump)

  ZSHZ[USE_FLOCK]=0
  ZSHZ[MV]=_mv_fail_n_times
  ZSHZ[MV_RETRIES]=4
  ZSHZ[MV_RETRY_DELAY]=1
  functions[zselect]='(( ++_delay_attempts )); return 1'

  zshz --add "$TESTDIR/p"
  first_rc=$?

  assert_eq "23" "$first_rc" "the terminal move status should be preserved"
  assert_eq "5" "$_mv_attempts" "four retries should mean five total attempts"
  assert_eq "4" "$_delay_attempts" "no delay should follow the final attempt"
  assert_eq "$before" "$(zshz_dump)" \
    "exhausted retries must leave the live datafile unchanged"
  _no_tempfile_in "$TESTDIR"

  # A second call gets a fresh four-retry budget; mv_attempts must be local to
  # zshz() rather than leaking its exhausted value across invocations.
  _mv_attempts=0
  _delay_attempts=0
  zshz --add "$TESTDIR/p"
  second_rc=$?

  assert_eq "23" "$second_rc" \
    "a second exhausted call should preserve the terminal move status"
  assert_eq "5" "$_mv_attempts" \
    "the retry budget should reset for each zshz invocation"
  assert_eq "4" "$_delay_attempts" \
    "the reset retry budget should include four delays"
  assert_eq "$before" "$(zshz_dump)" \
    "repeated exhaustion must leave the live datafile unchanged"
  _no_tempfile_in "$TESTDIR"
}

test_mv_retry_with_inherited_err_return_releases_flock() {
  (( ZSHZ[USE_FLOCK] )) || {
    _test_skip "zsystem flock unavailable"
    return 0
  }
  if [[ -f '/.dockerenv' ||
        ( -r '/proc/1/cgroup' && "$(< '/proc/1/cgroup')" == *docker* ) ]]; then
    _test_skip "Docker bind-mount path does not use rename"
    return 0
  fi

  setopt LOCAL_OPTIONS ERR_RETURN
  integer _mv_attempts=0 _mv_failures=1 _delay_attempts=0

  mkdir -p "$TESTDIR/p" "$TESTDIR/q"
  ZSHZ[MV]=_mv_fail_n_times
  ZSHZ[MV_RETRIES]=1
  ZSHZ[MV_RETRY_DELAY]=1
  functions[zselect]='(( ++_delay_attempts )); return 1'

  zshz --add "$TESTDIR/p"
  assert_eq "2" "$_mv_attempts" \
    "the flock branch should retry a transient rename failure"
  assert_ne "" "$(zshz_rank_of "$TESTDIR/p")" \
    "the flock-guarded retry should persist its update"

  # A subsequent writer must be able to acquire the lock after the retrying
  # call's always block releases its descriptor.
  ZSHZ[MV]=mv
  ZSHZ_LOCK_TIMEOUT=1
  zshz --add "$TESTDIR/q"
  assert_ne "" "$(zshz_rank_of "$TESTDIR/q")" \
    "the retrying call should release the flock for the next writer"
  _no_tempfile_in "$TESTDIR"
}

test_no_tempfile_after_lock_timeout() {
  # The lock-timeout path returns before opening the tempfile, so
  # there's nothing to clean up. This test pins that property -- a
  # future refactor that opens the tempfile before `flock' would
  # surface as a leak here.
  if ! (( ZSHZ[USE_FLOCK] )); then
    print "skip: zsystem flock unavailable"
    return 0
  fi

  mkdir -p "$TESTDIR/p"
  touch "${ZSHZ_DATA}.lock"

  zsh --no-rcs -c "
    zmodload zsh/system
    zsystem flock '${ZSHZ_DATA}.lock'
    sleep 3
  " &!
  local holder=$!
  sleep 0.2

  ZSHZ_LOCK_TIMEOUT=1 zshz --add "$TESTDIR/p"
  kill $holder 2>/dev/null

  _no_tempfile_in "$TESTDIR"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
