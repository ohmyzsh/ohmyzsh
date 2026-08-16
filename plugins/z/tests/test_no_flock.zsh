# `ZSHZ[USE_FLOCK]=0` fallback path: when `zsh/system` isn't available,
# `_zshz_add_or_remove_path` cannot use `zsystem flock` and serializes with an
# atomic `mkdir` on `${datafile}.lock.d` instead. Single-process add/remove
# behavior must hold, and so must serialization: this path used to write with
# nothing coordinating it, and 4 to 9 of 10 concurrent adds were lost on
# MobaXterm (whose cut-down Cygwin ships no `zsh/system`), occasionally taking
# every pre-seeded entry with them.
#
# These tests force `ZSHZ[USE_FLOCK]=0` so the fallback is exercised on every
# platform, not only where flock is genuinely missing.

test_add_works_without_flock() {
  ZSHZ[USE_FLOCK]=0
  zshz --add "$TESTDIR" || return 1
  assert_eq "1" "$(zshz_rank_of "$TESTDIR")" "--add should work without flock"
}

test_remove_works_without_flock() {
  mkdir -p "$TESTDIR/keep" "$TESTDIR/gone"
  ZSHZ[USE_FLOCK]=0
  zshz --add "$TESTDIR/keep"
  zshz --add "$TESTDIR/gone"
  zshz -x "$TESTDIR/gone"
  assert_ne "" "$(zshz_rank_of "$TESTDIR/keep")" "kept entry should remain"
  assert_eq "" "$(zshz_rank_of "$TESTDIR/gone")" "removed entry should be gone"
}

test_no_lockfile_created_without_flock() {
  ZSHZ[USE_FLOCK]=0
  zshz --add "$TESTDIR"
  if [[ -f "${ZSHZ_DATA}.lock" ]]; then
    fail "lockfile should not be created when USE_FLOCK=0"
  fi
}

test_no_flock_releases_its_lock_directory() {
  # The fallback lock is a directory, and unlike an fd it outlives the process
  # that made it -- a missed release wedges every later write rather than
  # leaking a descriptor.
  ZSHZ[USE_FLOCK]=0
  zshz --add "$TESTDIR" || return 1
  if [[ -e "${ZSHZ_DATA}.lock.d" ]]; then
    fail "the fallback lock directory must be released after a write"
  fi
  # A second write must still be able to take it.
  mkdir -p "$TESTDIR/again"
  zshz --add "$TESTDIR/again" || fail "a later write must still acquire the lock"
}

test_no_flock_breaks_a_stale_lock_directory() {
  # `mkdir` gives no release-on-death, so a holder that died would wedge the
  # database forever without this sweep. A write takes milliseconds; 30 seconds
  # old means nobody is coming back for it.
  ZSHZ[USE_FLOCK]=0
  mkdir -p "${ZSHZ_DATA}.lock.d"
  # Backdate it well past the staleness threshold. Try both `touch' spellings
  # and then *verify*, rather than trusting an exit status: MobaXterm's toybox
  # `touch' accepts `-d "2 minutes ago"' and returns 0 without applying it, so
  # a status-only check left the directory fresh and the test failing for the
  # wrong reason. The check uses the same `(ms+N)' age qualifier the plugin
  # itself does, which needs no `zsh/stat' -- MobaXterm has none.
  touch -d '2 minutes ago' "${ZSHZ_DATA}.lock.d" 2> /dev/null ||
    touch -t "$(strftime '%Y%m%d%H%M' $(( EPOCHSECONDS - 120 )))" "${ZSHZ_DATA}.lock.d" 2> /dev/null
  local -a backdated
  backdated=( ${ZSHZ_DATA}.lock.d(Nms+60) )
  if (( ! ${#backdated} )); then
    rmdir "${ZSHZ_DATA}.lock.d" 2> /dev/null
    _test_skip "cannot backdate a directory's mtime here"
    return 0
  fi

  mkdir -p "$TESTDIR/work"
  zshz --add "$TESTDIR/work" || fail "a stale lock directory must be broken, not waited on"
  assert_eq "1" "$(zshz_rank_of "$TESTDIR/work")" \
    "the write must land once the stale lock is cleared"
}

test_no_flock_lock_timeout_returns_2() {
  # A lock that is held but *not* stale must time out rather than be stolen,
  # and report the same status the flock path does for contention -- the `2`
  # the README documents.
  ZSHZ[USE_FLOCK]=0
  mkdir -p "${ZSHZ_DATA}.lock.d"
  mkdir -p "$TESTDIR/work"

  local ret=0
  ZSHZ_LOCK_TIMEOUT=1 zshz --add "$TESTDIR/work" || ret=$?
  assert_eq "2" "$ret" \
    "a held fallback lock must time out with status 2, as the README documents"
  assert_eq "" "$(zshz_rank_of "$TESTDIR/work")" \
    "a write that could not take the lock must not have landed"

  rmdir "${ZSHZ_DATA}.lock.d"
}

test_no_flock_concurrent_writes_do_not_lose_updates() {
  # The regression this fallback exists for. Writers are external processes so
  # the lock is exercised across real OS processes, and each one forces
  # USE_FLOCK=0 for itself -- a child re-sourcing the plugin would otherwise
  # detect flock and take the other path.
  local n=10 i
  local -a names
  for ((i=1; i<=n; i++)); do
    mkdir -p "$TESTDIR/w_$i"
    names+=( "$TESTDIR/w_$i" )
  done

  printf '%s\n' "${names[@]}" | ( xargs_P 4 \
    env ZSHZ_LOCK_TIMEOUT=30 zsh -c \
      "source '$PLUGIN_DIR/zsh-z.plugin.zsh'; ZSHZ[USE_FLOCK]=0; zshz --add '{}'" )

  # `local -a missing', not `local missing=()': on Zsh 4.3.11 the latter does
  # not reliably produce an empty array, and the mis-parse that follows hangs
  # the runner in a fork loop rather than failing outright.
  local -a missing
  for ((i=1; i<=n; i++)); do
    [[ -n $(zshz_rank_of "$TESTDIR/w_$i") ]] || missing+=( "w_$i" )
  done
  assert_eq "" "${(j:, :)missing}" \
    "every concurrent add must survive the fallback lock"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
