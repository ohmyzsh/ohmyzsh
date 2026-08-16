# Sourcing the plugin under strict zsh options.
#
# Some users put `setopt NO_UNSET WARN_CREATE_GLOBAL NO_NOMATCH' (or
# variants) in their .zshrc to catch sloppy scripting. The plugin
# already explicitly guards `_zshz_precmd' against NO_UNSET (line 967:
# `setopt LOCAL_OPTIONS UNSET'), but that's only one entry point. This
# file pins the broader contract: with each of these options active at
# source time, sourcing the plugin and exercising it must produce
# zero noise on stderr.
#
# The test runner already fails on any non-empty stderr, so we don't
# need to assert on stderr explicitly -- a regression that emits a
# warning will surface as a normal test failure.

_zshz_test_zsh_bin() {
  local bin
  bin=$(readlink /proc/$$/exe 2>/dev/null)
  [[ -x $bin ]] && { print -- $bin; return }
  print -- ${commands[zsh]:-zsh}
}

_zshz_test_strict_round_trip() {
  local opts=$1 zsh_bin
  zsh_bin=$(_zshz_test_zsh_bin)
  mkdir -p "$TESTDIR/work"

  # The child shell's stderr propagates up to this test's stderr; the
  # runner fails the test if anything appears there.
  local out
  out=$("$zsh_bin" --no-rcs -c "
    setopt $opts
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    zshz --add '$TESTDIR/work'
    _zshz_precmd
    # Wait for the disowned precmd write to land.
    local i
    for ((i=0; i<40; i++)); do
      [[ -n \$(awk -F'|' -v p='$TESTDIR/work' '\$1==p { print \$2 }' '$TESTDIR/.z' 2>/dev/null) ]] && break
      sleep 0.05
    done
    zshz -l
  ")
  local rc=$?

  assert_eq "0" "$rc" "$opts: round-trip should succeed"
  assert_contains "$TESTDIR/work" "$out" \
    "$opts: list output should contain the added path"
}

test_source_with_NO_UNSET() {
  _zshz_test_strict_round_trip 'NO_UNSET'
}

test_source_with_WARN_CREATE_GLOBAL() {
  _zshz_test_strict_round_trip 'WARN_CREATE_GLOBAL'
}

test_source_with_NO_NOMATCH() {
  _zshz_test_strict_round_trip 'NO_NOMATCH'
}

test_source_with_combined_strict_options() {
  _zshz_test_strict_round_trip 'NO_UNSET WARN_CREATE_GLOBAL NO_NOMATCH'
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
