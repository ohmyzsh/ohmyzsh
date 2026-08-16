# Smoke tests for the core --add / -x / -l / -e behaviors.

# Same self-locator used in test_config_errors.zsh / test_emulate.zsh /
# test_strict_options.zsh.
_zshz_test_zsh_bin() {
  local bin
  bin=$(readlink /proc/$$/exe 2>/dev/null)
  [[ -x $bin ]] && { print -- $bin; return }
  print -- ${commands[zsh]:-zsh}
}

test_add_creates_entry_with_rank_1() {
  zshz --add "$TESTDIR" || return 1
  assert_eq "1" "$(zshz_rank_of "$TESTDIR")" "rank after one add"
}

test_add_same_path_twice_increments_rank() {
  zshz --add "$TESTDIR"
  zshz --add "$TESTDIR"
  assert_eq "2" "$(zshz_rank_of "$TESTDIR")" "rank after two adds"
}

test_add_skips_HOME() {
  zshz --add "$HOME"
  local rank
  rank=$(zshz_rank_of "$HOME")
  assert_eq "" "$rank" "\$HOME should not be added"
}

test_add_skips_excluded_dir() {
  local sub="$TESTDIR/excluded"
  mkdir -p "$sub"
  ZSHZ_EXCLUDE_DIRS=( "$sub" ) zshz --add "$sub"
  assert_eq "" "$(zshz_rank_of "$sub")" "excluded dir should not be added"
}

test_add_skips_subtree_of_excluded_dir() {
  local sub="$TESTDIR/excluded"
  mkdir -p "$sub/child"
  ZSHZ_EXCLUDE_DIRS=( "$sub" ) zshz --add "$sub/child"
  assert_eq "" "$(zshz_rank_of "$sub/child")" "subtree of excluded dir should not be added"
}

test_add_nonexistent_path_returns_nonzero() {
  zshz --add "$TESTDIR/does-not-exist" 2> /dev/null
  local rc=$?
  assert_ne "0" "$rc" "adding a missing path should fail"
}

test_remove_drops_entry() {
  zshz --add "$TESTDIR"
  cd "$TESTDIR"
  zshz -x
  assert_eq "" "$(zshz_rank_of "$TESTDIR")" "entry should be gone after -x"
}

test_remove_R_drops_subtree() {
  local a="$TESTDIR/a" b="$TESTDIR/a/b" c="$TESTDIR/c"
  mkdir -p "$a" "$b" "$c"
  zshz --add "$a"
  zshz --add "$b"
  zshz --add "$c"
  cd "$a"
  zshz -xR
  assert_eq "" "$(zshz_rank_of "$a")" "$a should be removed"
  assert_eq "" "$(zshz_rank_of "$b")" "$b (subtree) should be removed"
  assert_eq "1" "$(zshz_rank_of "$c")" "$c (sibling) should remain"
}

test_remove_R_missing_path_leaves_database_alone() {
  local a="$TESTDIR/a" b="$TESTDIR/a/b"
  mkdir -p "$b"
  zshz --add "$a"
  zshz --add "$b"
  zshz -xR "$TESTDIR/does-not-exist" 2> /dev/null
  local rc=$?
  assert_ne "0" "$rc" "-xR on a missing path should report failure"
  assert_eq "1" "$(zshz_rank_of "$a")" "$a must survive -xR on a missing path"
  assert_eq "1" "$(zshz_rank_of "$b")" "$b must survive -xR on a missing path"
}

test_remove_deleted_dir_entry() {
  # A stale entry whose directory no longer exists is exactly the one a user
  # most wants out of the database, so `-x' must not require the directory
  # to still be on disk.
  local gone="$TESTDIR/gone"
  mkdir -p "$gone"
  zshz --add "$gone"
  rm -rf "$gone"
  zshz -x "$gone" || return 1
  assert_eq "" "$(zshz_rank_of "$gone")" "stale entry should be removable with -x"
}

test_remove_R_deleted_dir_drops_subtree() {
  local a="$TESTDIR/a" b="$TESTDIR/a/b" c="$TESTDIR/c"
  mkdir -p "$b" "$c"
  zshz --add "$a"
  zshz --add "$b"
  zshz --add "$c"
  rm -rf "$a"
  zshz -xR "$TESTDIR/a" || return 1
  assert_eq "" "$(zshz_rank_of "$a")" "stale $a should be removed"
  assert_eq "" "$(zshz_rank_of "$b")" "stale $b (subtree) should be removed"
  assert_eq "1" "$(zshz_rank_of "$c")" "$c (sibling) should remain"
}

test_remove_missing_toplevel_path_does_not_segfault() {
  # `${x:A}' segfaults Zsh 4.3.11 when the top-level component of the path
  # does not exist, so `z -x /gone/sub' used to kill the user's interactive
  # shell there (the old `[[ -d ${...:A} ]]' guard crashed inside the test
  # itself). _zshz_realpath keeps such paths away from `:A'. Run the removal
  # in a disposable shell of the same Zsh so a regression reports as a
  # missing sentinel, not a dead test subshell.
  local zsh_bin out gone="/zshz-segv-$$-$RANDOM/sub"
  zsh_bin=$(_zshz_test_zsh_bin)
  zshz_seed "$gone" 1

  out=$("$zsh_bin" --no-rcs -c "
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    zshz -x '$gone'
    print POST_REMOVE_SENTINEL
  " 2>&1)

  assert_contains "POST_REMOVE_SENTINEL" "$out" \
    "removing a path under a missing top-level directory must not kill the shell"
  assert_eq "" "$(zshz_rank_of "$gone")" \
    "entry under a missing top-level directory should be removed"
}

test_list_shows_added_paths() {
  local a="$TESTDIR/alpha" b="$TESTDIR/beta"
  mkdir -p "$a" "$b"
  zshz --add "$a"
  zshz --add "$b"
  local out
  out=$(zshz -l 2>&1)
  assert_contains "$a" "$out" "-l should list $a"
  assert_contains "$b" "$out" "-l should list $b"
}

test_echo_returns_best_match() {
  local a="$TESTDIR/alpha" b="$TESTDIR/alphabet"
  mkdir -p "$a" "$b"
  zshz --add "$a"
  zshz --add "$a"
  zshz --add "$b"
  local out
  out=$(zshz -e alpha 2>&1)
  assert_contains "alpha" "$out" "-e should echo a match for 'alpha'"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
