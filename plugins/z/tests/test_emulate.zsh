# Sourcing under non-zsh emulation modes (emulate sh / bash / ksh).
#
# zsh-z uses Zsh-only syntax in function bodies (extended-glob `##'
# quantifiers, `(M)' and `(@)' parameter-expansion flags, etc.). Those
# constructs fail to parse when the calling shell is in sh/bash/ksh
# emulation -- and many users have `emulate sh' or `emulate bash' in
# their .zshrc.
#
# The plugin's gate at the top of zsh-z.plugin.zsh detects non-zsh
# emulation via `[[ -o KSH_ARRAYS || -o SH_WORD_SPLIT ]]' and
# re-sources itself under `emulate zsh -c' so the body parses
# correctly. The gate uses `${(%):-%N}' for the script's own path
# because `$0' is the shell binary under emulate sh, not the sourced
# file.
#
# Each test below spawns a fresh child shell, switches to the target
# emulation, sources the plugin, then exercises a basic --add/-l
# round-trip. Linux-only via /proc/$$/exe (existing concurrency tests
# already assume this).

# Pick the same zsh binary the test runner is using, falling back to
# whatever is in PATH.
_zshz_test_zsh_bin() {
  local bin
  bin=$(readlink /proc/$$/exe 2>/dev/null)
  [[ -x $bin ]] && { print -- $bin; return }
  print -- ${commands[zsh]:-zsh}
}

_zshz_test_emulate_round_trip() {
  local mode=$1 zsh_bin
  zsh_bin=$(_zshz_test_zsh_bin)
  mkdir -p "$TESTDIR/work"

  local out
  out=$("$zsh_bin" --no-rcs -c "
    $mode
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    zshz --add '$TESTDIR/work'
    zshz -l
  " 2>&1)
  local rc=$?

  assert_eq "0" "$rc" "$mode: source + add + list should succeed (output: $out)"
  assert_contains "$TESTDIR/work" "$out" \
    "$mode: list output should contain the added path"
}

test_source_under_emulate_sh() {
  _zshz_test_emulate_round_trip 'emulate sh'
}

test_source_under_emulate_sh_R() {
  _zshz_test_emulate_round_trip 'emulate sh -R'
}

test_source_under_emulate_bash() {
  _zshz_test_emulate_round_trip 'emulate bash'
}

test_source_under_emulate_ksh() {
  _zshz_test_emulate_round_trip 'emulate ksh'
}

test_source_from_path_with_spaces_under_emulate_sh() {
  # Regression: the emulation gate re-sources the plugin with
  # `emulate zsh -c "source ${(q)${(%):-%N}}"'. Without the `${(q)}'
  # quoting the script's own path is word-split, so an install directory
  # containing a space makes `source' receive several arguments and the
  # plugin silently fails to load. Copy the plugin into a spaced
  # directory and confirm a full round-trip still works under emulate sh.
  local zsh_bin
  zsh_bin=$(_zshz_test_zsh_bin)
  local spaced="$TESTDIR/dir with spaces"
  mkdir -p "$spaced" "$TESTDIR/work"
  cp "$PLUGIN_DIR/zsh-z.plugin.zsh" "$PLUGIN_DIR/_zshz" "$spaced/"

  local out
  out=$("$zsh_bin" --no-rcs -c "
    emulate sh
    source '$spaced/zsh-z.plugin.zsh'
    zshz --add '$TESTDIR/work'
    zshz -l
  " 2>&1)
  local rc=$?

  assert_eq "0" "$rc" \
    "emulate sh from spaced path: round-trip should succeed (output: $out)"
  assert_contains "$TESTDIR/work" "$out" \
    "emulate sh from spaced path: list output should contain the added path"
}

test_emulate_gate_does_not_fire_under_pure_zsh() {
  # Under pure zsh the gate's option check should be false and the
  # plugin should source directly without recursing through
  # `emulate zsh -c "source ..."'. Verify by: (a) sourcing succeeds,
  # and (b) `zshz --add' lands an entry as usual.
  local zsh_bin
  zsh_bin=$(_zshz_test_zsh_bin)
  mkdir -p "$TESTDIR/work"

  local out
  out=$("$zsh_bin" --no-rcs -c "
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    zshz --add '$TESTDIR/work'
    zshz -l
  " 2>&1)
  local rc=$?

  assert_eq "0" "$rc" "pure zsh: round-trip should succeed (output: $out)"
  assert_contains "$TESTDIR/work" "$out" \
    "pure zsh: list output should contain the added path"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
