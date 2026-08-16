# Hook behavior for precmd/chpwd integration.
#
# `_zshz_precmd' backgrounds `zshz --add' via `&!' (fork + disown) so the
# prompt doesn't wait on the read+tempfile+rename+chown round-trip. The
# helper below waits for the disowned write to land before asserting; `wait'
# can't see a `&!'-disowned job, so we poll the datafile.

# Wait up to 2s for $1 to appear in the datafile. Returns 0 once the entry is
# present, 1 on timeout.
_wait_for_add() {
  local target=$1 i
  for ((i=0; i<40; i++)); do
    [[ -n $(zshz_rank_of "$target") ]] && return 0
    sleep 0.05
  done
  return 1
}

# Wait up to 2s for $1 to be absent from the datafile.
_wait_for_remove() {
  local target=$1 i
  for ((i=0; i<40; i++)); do
    [[ -z $(zshz_rank_of "$target") ]] && return 0
    sleep 0.05
  done
  return 1
}

test_precmd_adds_pwd() {
  mkdir -p "$TESTDIR/work"
  cd "$TESTDIR/work"

  _zshz_precmd
  _wait_for_add "$TESTDIR/work"

  assert_eq "1" "$(zshz_rank_of "$TESTDIR/work")" "_zshz_precmd should add PWD"
}

test_precmd_skips_home_and_excluded_dirs() {
  local HOME="$TESTDIR/home"
  mkdir -p "$HOME" "$TESTDIR/excluded/child"
  ZSHZ_EXCLUDE_DIRS=( "$TESTDIR/excluded" )

  cd "$HOME"
  _zshz_precmd
  # No backgrounded write to wait on -- precmd returns before reaching `&!'.
  assert_eq "" "$(zshz_rank_of "$HOME")" "_zshz_precmd should skip HOME"

  cd "$TESTDIR/excluded/child"
  _zshz_precmd
  assert_eq "" "$(zshz_rank_of "$TESTDIR/excluded/child")" "_zshz_precmd should skip excluded subtrees"
}

test_removed_directory_is_not_readded_until_chpwd() {
  mkdir -p "$TESTDIR/work"
  cd "$TESTDIR/work"

  _zshz_precmd
  _wait_for_add "$TESTDIR/work"
  zshz -x "$TESTDIR/work"
  assert_eq "" "$(zshz_rank_of "$TESTDIR/work")" "directory should be removed by -x"

  _zshz_precmd
  # The DIRECTORY_REMOVED guard makes precmd return early, so no add to wait
  # for; sleep briefly to confirm nothing sneaks in late.
  sleep 0.1
  assert_eq "" "$(zshz_rank_of "$TESTDIR/work")" "_zshz_precmd should not immediately re-add a removed directory"

  _zshz_chpwd
  _zshz_precmd
  _wait_for_add "$TESTDIR/work"
  assert_eq "1" "$(zshz_rank_of "$TESTDIR/work")" "_zshz_chpwd should allow later re-addition"
}

test_precmd_does_not_emit_done_line_in_interactive_shell() {
  # Verify the user-visible promise of `&!' in `_zshz_precmd': in an
  # interactive shell, the backgrounded `zshz --add' must not produce
  # a "[N]  + done" notification at the next prompt.
  #
  # The function-call boundary of `_zshz_precmd' alone is NOT enough to
  # suppress that line -- with MONITOR on (default in interactive zsh),
  # plain `cmd &' inside a function still surfaces a Done notification
  # at the next prompt. `&!' (background + disown) is what suppresses it,
  # and that's the contract this test pins down.
  #
  # The probe uses `zsh/zpty' to drive a real pty-backed interactive zsh.
  # Reads are timing-based -- pattern-matched reads (`zpty -r p v PAT')
  # are unreliable on zsh 4.3.11, and the fixed sleeps below assume
  # Linux pty timing. On Solaris the pty isn't ready quickly enough,
  # eating the first character of `PS1=' and derailing the subsequent
  # `cd' (the inner shell drops into a `>>>' continuation prompt and
  # later precmd calls record $TESTDIR instead of $TESTDIR/work). The
  # contract being tested -- that `&!' suppresses the "Done" line --
  # is inherent to zsh's job control, so Linux coverage is enough.
  [[ $OSTYPE == linux* ]] || { print "skip: non-Linux pty timing"; return 0 }
  zmodload zsh/zpty 2>/dev/null
  if ! (( ${+modules[zsh/zpty]} )); then
    print "skip: zsh/zpty unavailable"
    return 0
  fi

  local zsh_bin
  zsh_bin=$(readlink /proc/$$/exe 2>/dev/null)
  [[ -x $zsh_bin ]] || zsh_bin=${commands[zsh]}
  if [[ ! -x $zsh_bin ]]; then
    print "skip: no zsh binary located"
    return 0
  fi

  mkdir -p "$TESTDIR/work"

  # `zpty -b' can fail even after `zmodload zsh/zpty' succeeds: on
  # Cygwin the module loads but no pseudo-terminal is available
  # ("can't open pseudo terminal: bad file descriptor"). Treat that as
  # a platform skip rather than a test failure -- if the inner zsh
  # can't get a pty, the &!/Done-line behavior simply can't be
  # exercised here.
  if ! zpty -b z_probe "$zsh_bin -i --no-rcs -d -f" 2>/dev/null; then
    print "skip: zpty cannot open a pty on this platform"
    return 0
  fi
  sleep 0.3
  zpty -w z_probe "PS1='ZTEST>'"$'\n'
  zpty -w z_probe "setopt MONITOR"$'\n'
  zpty -w z_probe "source '$PLUGIN_DIR/zsh-z.plugin.zsh'"$'\n'
  zpty -w z_probe "cd '$TESTDIR/work'"$'\n'
  zpty -w z_probe "_zshz_precmd"$'\n'
  # Wait for the disowned `zshz --add' to finish writing the datafile.
  sleep 0.5
  # Send a no-op so any pending Done notification surfaces at the next
  # prompt rendering.
  zpty -w z_probe ":"$'\n'
  sleep 0.2
  zpty -w z_probe "exit"$'\n'
  sleep 0.2

  local out= chunk
  while zpty -r z_probe chunk; do out+=$chunk; done 2>/dev/null
  zpty -d z_probe 2>/dev/null

  if [[ $out == *"+ done"* ]]; then
    fail "&! promise broken: interactive precmd surfaced a '+ done' line"
  fi

  # Sanity: SOMETHING landed in the datafile. The interactive zpty
  # session triggers precmd at every prompt (initial, after cd, after
  # the `:'), so the exact rank is whatever-precmd-fired-times rather
  # than 1. We only check that the write path worked at all.
  #
  # The disowned `zshz --add' is reparented to init when zpty -d closes
  # the inner zsh, and may not have finished writing by the time we
  # reach this point on a slow host. Poll for up to 5s. On failure,
  # dump the datafile so a path mismatch (e.g. /tmp resolving to a
  # different canonical path inside the zpty session) is distinguishable
  # from a missed-write timeout.
  local rank deadline=$(( EPOCHSECONDS + 5 ))
  while (( EPOCHSECONDS < deadline )); do
    rank=$(zshz_rank_of "$TESTDIR/work")
    [[ -n $rank ]] && (( rank >= 1 )) && break
    sleep 0.1
  done
  if [[ -z $rank ]] || (( rank < 1 )); then
    local dump
    dump=$(zshz_dump)
    # On a failure here, the most useful thing to see is what the inner
    # zsh actually printed back -- a cd error, a parse error on some
    # input line, or just a missing prompt all look the same from the
    # outside otherwise. `$out' was already drained above for the
    # `+ done' check; reuse it.
    local pty_out=${out//$'\r'/}
    fail "backgrounded write never landed (rank=$rank); looked up '$TESTDIR/work'; datafile: ${dump:-<empty>}; pty output: <<<${pty_out}>>>"
  fi
}

test_repeated_precmd_under_prompt_spam() {
  # Hammer `_zshz_precmd' in a tight loop and verify:
  #   1. The calling shell holds no lockfile fd afterward. In the
  #      current async precmd, lock acquisition happens inside the
  #      disowned `zshz --add' child's own fd table -- the parent
  #      should never end up holding one. This guards against a future
  #      refactor that makes precmd synchronous without preserving the
  #      `always { ... zsystem flock -u }' discipline in
  #      `_zshz_add_or_remove_path'.
  #   2. Several disowned writes actually land in the datafile.
  #
  # N is modest because zsh 4.3.11's `&'/`wait' machinery segfaults
  # under heavier fork load (see test_concurrency.zsh's note about
  # spawning external `zsh -c' processes). The
  # `test_lock_fd_does_not_leak_across_repeated_adds' regression
  # covers the synchronous-`--add' fd-leak path with an external probe;
  # this test complements it on the precmd path.
  [[ -d /proc/self/fd ]] || { print "skip: /proc/self/fd unavailable"; return 0; }

  mkdir -p "$TESTDIR/work"
  cd "$TESTDIR/work"

  # Give the disowned children a generous window to acquire the lock, so a
  # slow or contended CI runner doesn't drop writes against the 1s default and
  # leave us under the floor. We are checking that the precmd write path works,
  # not the contention drop-rate (test_lock_timeout covers that). `&!' forks
  # the current shell, so the child `zshz --add' inherits this local; no export.
  local ZSHZ_LOCK_TIMEOUT=30

  local i n=30
  for ((i=0; i<n; i++)); do
    _zshz_precmd
  done

  local rank min_rank=5
  is-at-least 5 || min_rank=2

  # The floor applies on every platform: writes are serialized by `zsystem
  # flock' where it exists and by the `mkdir' fallback where it does not. It
  # was briefly relaxed without flock, when that path had no lock at all and
  # MobaXterm landed 4 of 30 disowned adds; with the fallback lock it keeps up.

  # Drain: poll until at least min_rank writes have landed, or give up after a
  # generous deadline. (The previous "stop when the rank holds steady for one
  # 0.1s tick" exited early on a transient stall while disowned children were
  # still landing -- the cause of the rank=3 flake on a loaded CI runner.)
  local deadline=$(( EPOCHSECONDS + 20 ))
  while (( EPOCHSECONDS < deadline )); do
    rank=$(zshz_rank_of "$TESTDIR/work")
    [[ -n $rank ]] && (( rank >= min_rank )) && break
    sleep 0.1
  done

  # Inspect this shell's own fd table via /proc/self/fd. We resolve the
  # symlink targets via zsh's `:A' modifier rather than external
  # `readlink' / `lsof', because `zsystem flock' opens its lockfd with
  # FD_CLOEXEC -- a forked `readlink' would see those fds as already
  # closed and miss the leak entirely. `$$' is the wrong pid here too:
  # in zsh `$$' refers to the parent shell, not the subshell that ran
  # `_zshz_precmd', so anything spawning a child to inspect "this
  # shell's" fds would also miss the target process.
  local fd link
  local -a leaks
  local lockname=${ZSHZ_DATA##*/}.lock
  for fd in /proc/self/fd/*(N); do
    link=${fd:A}
    [[ $link == *$lockname* ]] && leaks+=( "$fd -> $link" )
  done
  if (( ${#leaks} )); then
    fail "calling shell holds lockfile fds: ${(j:; :)leaks}"
  fi

  # And the disowned writes must have landed. We don't require rank == n (a
  # child can still lose the lock race), only a clear sign the precmd write
  # path worked: min_rank on modern zsh, relaxed on 4.3.11 whose fork machinery
  # is slow enough that fewer children land within the window, and relaxed
  # again with no flock, where the count is the platform's business.
  rank=$(zshz_rank_of "$TESTDIR/work")
  if [[ -z $rank ]] || (( rank < min_rank )); then
    fail "expected at least $min_rank disowned write(s) to land; got rank=${rank:-(empty)} (USE_FLOCK=${ZSHZ[USE_FLOCK]})"
  fi
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
