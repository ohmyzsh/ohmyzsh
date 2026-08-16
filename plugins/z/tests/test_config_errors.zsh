# Plugin config errors must `return', not `exit'.
#
# Covers commit 1747969 ("Avoid exiting the shell on plugin config
# errors"). Three error paths -- (a) the `is-at-least 4.3.11' check at
# the top of the file, (b) a bare-filename ZSHZ_DATA, (c) ZSHZ_DATA
# pointing at a directory -- must all surface their error message and
# bail without taking the user's interactive shell down with them.
#
# `test_datafile.zsh' already covers (b) and (c) by checking that
# `zshz -l && print SENTINEL' doesn't print SENTINEL -- but that
# assertion can't distinguish "zshz returned non-zero" from "the whole
# shell exited," because both produce the same observable. The tests
# below probe the stronger property: a sentinel placed *after* the
# failing call must still print, which only happens if the calling
# shell stayed alive.
#
# Surviving the error is only half of it. Once `zshz' returns instead
# of exiting, a bad $ZSHZ_DATA persists -- and `_zshz_precmd' runs
# `zshz --add' before every prompt, so the same diagnostic came back
# once per prompt for the life of the shell. The fork can't warn just
# once: `&!' means it cannot record "already warned" anywhere its
# parent will see. `_zshz_precmd' therefore marks its own call with a
# `local _zshz_quiet_add' and `zshz' skips the diagnostic when it sees
# it. The second group of tests pins down all three halves of that
# bargain: the hook is silent, a hand-typed `z --add' is not, and the
# marker never escapes into the surrounding shell.

# Same self-locator used in test_emulate.zsh / test_strict_options.zsh.
_zshz_test_zsh_bin() {
  local bin
  bin=$(readlink /proc/$$/exe 2>/dev/null)
  [[ -x $bin ]] && { print -- $bin; return }
  print -- ${commands[zsh]:-zsh}
}

test_old_zsh_version_check_returns_does_not_exit() {
  # Shim `is-at-least' to return false, so the version-check branch
  # fires. `autoload' is also shimmed to a no-op so the plugin's
  # `autoload -Uz is-at-least' line doesn't replace our shim with an
  # autoload stub before the check runs. The plugin's
  # `return 1 2>/dev/null || exit 1' should hit the `return' branch
  # (we're being sourced) and the calling shell must continue past
  # the source.
  local zsh_bin out
  zsh_bin=$(_zshz_test_zsh_bin)

  out=$("$zsh_bin" --no-rcs -c "
    autoload() { : }
    is-at-least() { return 1 }
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    print POST_SOURCE_SENTINEL
  " 2>&1)

  assert_contains "Zsh-z requires" "$out" \
    "version-check failure should print the user-facing error"
  assert_contains "POST_SOURCE_SENTINEL" "$out" \
    "calling shell should survive a version-check failure"
}

test_bare_ZSHZ_DATA_returns_does_not_exit() {
  # ZSHZ_DATA without a directory component must fail zshz cleanly,
  # leaving the calling shell intact.
  local zsh_bin out
  zsh_bin=$(_zshz_test_zsh_bin)

  out=$("$zsh_bin" --no-rcs -c "
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    ZSHZ_DATA=barefile zshz -l
    print POST_BARE_SENTINEL
  " 2>&1)

  assert_contains "barefile" "$out" \
    "bare-filename ZSHZ_DATA should produce the user-facing error"
  assert_contains "POST_BARE_SENTINEL" "$out" \
    "calling shell should survive a bare-filename ZSHZ_DATA"
}

test_directory_ZSHZ_DATA_returns_does_not_exit() {
  # ZSHZ_DATA pointing at a directory must fail zshz cleanly, leaving
  # the calling shell intact.
  local zsh_bin out
  zsh_bin=$(_zshz_test_zsh_bin)
  mkdir -p "$TESTDIR/data-dir"

  out=$("$zsh_bin" --no-rcs -c "
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    ZSHZ_DATA='$TESTDIR/data-dir' zshz -l
    print POST_DIR_SENTINEL
  " 2>&1)

  assert_contains "is a directory" "$out" \
    "directory ZSHZ_DATA should produce the user-facing error"
  assert_contains "POST_DIR_SENTINEL" "$out" \
    "calling shell should survive a directory ZSHZ_DATA"
}

test_missing_toplevel_ZSHZ_DATA_returns_does_not_exit() {
  # The datafile path is canonicalized on every zshz call, including the
  # backgrounded precmd add, and `${x:A}' on a path whose top-level
  # component does not exist segfaults Zsh 4.3.11 -- so this $ZSHZ_DATA
  # used to kill a shell there at every prompt. Only survival is asserted:
  # such a datafile cannot be created, so the call still fails, loudly,
  # like the other bad-datafile cases above.
  local zsh_bin out
  zsh_bin=$(_zshz_test_zsh_bin)

  out=$("$zsh_bin" --no-rcs -c "
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    ZSHZ_DATA='/zshz-segv-$$-$RANDOM/x/.z' zshz -l
    print POST_MISSING_TOPLEVEL_SENTINEL
  " 2>&1)

  assert_contains "POST_MISSING_TOPLEVEL_SENTINEL" "$out" \
    "calling shell should survive a ZSHZ_DATA under a missing top-level directory"
}

# The disowned `&!' add can't be waited for -- `wait' doesn't see it --
# and a misconfigured datafile means there's no file to poll, either.
# Give the forks a moment to produce output they shouldn't produce.
# Generous rather than tight: a false PASS from sampling too early is
# worse than half a second, and forks are slow on Cygwin/MSYS2.
_ZSHZ_FORK_SETTLE=0.5

test_precmd_add_is_silent_when_ZSHZ_DATA_is_a_directory() {
  # Five prompts' worth of hook must produce nothing at all.
  local zsh_bin out
  zsh_bin=$(_zshz_test_zsh_bin)
  mkdir -p "$TESTDIR/data-dir" "$TESTDIR/work"

  out=$("$zsh_bin" --no-rcs -c "
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    ZSHZ_DATA='$TESTDIR/data-dir'
    builtin cd '$TESTDIR/work'
    for i in 1 2 3 4 5; do _zshz_precmd; done
    sleep $_ZSHZ_FORK_SETTLE
    print POST_PRECMD_SENTINEL
  " 2>&1)

  assert_not_contains "is a directory" "$out" \
    "the pre-prompt add must not report a bad datafile at every prompt"
  assert_contains "POST_PRECMD_SENTINEL" "$out" \
    "calling shell should survive a directory ZSHZ_DATA at precmd time"
}

test_precmd_add_is_silent_when_ZSHZ_DATA_is_a_bare_filename() {
  local zsh_bin out
  zsh_bin=$(_zshz_test_zsh_bin)
  mkdir -p "$TESTDIR/work"

  out=$("$zsh_bin" --no-rcs -c "
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    ZSHZ_DATA=barefile
    builtin cd '$TESTDIR/work'
    for i in 1 2 3 4 5; do _zshz_precmd; done
    sleep $_ZSHZ_FORK_SETTLE
    print POST_PRECMD_SENTINEL
  " 2>&1)

  assert_not_contains "have not specified its directory" "$out" \
    "the pre-prompt add must not report a bare-filename datafile at every prompt"
  assert_contains "POST_PRECMD_SENTINEL" "$out" \
    "calling shell should survive a bare-filename ZSHZ_DATA at precmd time"
}

test_manual_add_still_reports_a_bad_ZSHZ_DATA() {
  # Only the hook's add is quiet. `z --add' typed by hand is a direct
  # request and must still explain why it failed -- otherwise silencing
  # the hook would have cost the user a diagnostic they asked for.
  local zsh_bin out
  zsh_bin=$(_zshz_test_zsh_bin)
  mkdir -p "$TESTDIR/data-dir" "$TESTDIR/work"

  out=$("$zsh_bin" --no-rcs -c "
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    ZSHZ_DATA='$TESTDIR/data-dir' zshz --add '$TESTDIR/work'
    print POST_MANUAL_ADD_SENTINEL
  " 2>&1)

  assert_contains "is a directory" "$out" \
    "a hand-typed 'z --add' should still report a bad datafile"
  assert_contains "POST_MANUAL_ADD_SENTINEL" "$out" \
    "calling shell should survive a hand-typed 'z --add'"
}

test_precmd_quiet_marker_does_not_leak_into_the_shell() {
  # `_zshz_quiet_add' is a `local' in `_zshz_precmd', reached by dynamic
  # scope. Were it ever to become a global, the first prompt would
  # silence every later `zshz' call in that shell -- including the
  # interactive ones this whole file exists to protect. Run the hook
  # against a *good* datafile, then check both halves.
  local zsh_bin out
  zsh_bin=$(_zshz_test_zsh_bin)
  mkdir -p "$TESTDIR/data-dir" "$TESTDIR/work"

  out=$("$zsh_bin" --no-rcs -c "
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    builtin cd '$TESTDIR/work'
    _zshz_precmd
    sleep $_ZSHZ_FORK_SETTLE
    print \"MARKER=[\${_zshz_quiet_add-unset}]\"
    ZSHZ_DATA='$TESTDIR/data-dir' zshz -l
  " 2>&1)

  assert_contains "MARKER=[unset]" "$out" \
    "the precmd quiet marker must not survive into the calling shell"
  assert_contains "is a directory" "$out" \
    "an interactive call after a precmd add must still report a bad datafile"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
