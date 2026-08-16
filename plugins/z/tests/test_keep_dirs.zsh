# `ZSHZ_KEEP_DIRS': edge cases beyond the simple subtree-protection
# already covered by `test_cleanup.zsh'.
#
# `_zshz_update_datafile' (line 401-) and `_zshz_find_matches'
# (line 671-) both run the same prune-missing-directories loop:
# entries whose backing dir doesn't exist are dropped UNLESS the
# entry path matches `${keep}/*', equals `$keep', or `$keep' itself
# is `/'. Both call sites must honour KEEP_DIRS the same way -- the
# rewrite-time pruning is what `test_cleanup.zsh' covers; the
# read-time pruning is what one of these tests covers.

test_keep_dirs_protects_many_entries_under_one_root() {
  # Stronger version of `test_keep_dirs_protects_subtree': several
  # entries under one KEEP_DIRS root, all preserved at their original
  # ranks, after the dir is deleted and a rewrite is forced.
  mkdir -p "$TESTDIR/holdme/a" "$TESTDIR/holdme/b" "$TESTDIR/holdme/c/inner" "$TESTDIR/trigger"
  zshz_seed "$TESTDIR/holdme/a"        3 60
  zshz_seed "$TESTDIR/holdme/b"        7 60
  zshz_seed "$TESTDIR/holdme/c/inner" 11 60
  rm -rf "$TESTDIR/holdme"

  ZSHZ_KEEP_DIRS=( "$TESTDIR/holdme" ) zshz --add "$TESTDIR/trigger"

  assert_eq "3"  "$(zshz_rank_of "$TESTDIR/holdme/a")"        "first kept entry"
  assert_eq "7"  "$(zshz_rank_of "$TESTDIR/holdme/b")"        "second kept entry"
  assert_eq "11" "$(zshz_rank_of "$TESTDIR/holdme/c/inner")"  "third kept entry"
}

test_keep_dirs_root_slash_protects_everything() {
  # The `$dir == '/'' branch: `KEEP_DIRS=( / )' is a documented
  # escape hatch that suppresses the missing-dir prune entirely.
  # `test_scale.zsh' relies on this so it doesn't have to mkdir
  # 5000 stub directories; the contract had no dedicated test
  # before this one.
  mkdir -p "$TESTDIR/elsewhere1" "$TESTDIR/elsewhere2" "$TESTDIR/trigger"
  zshz_seed "$TESTDIR/elsewhere1" 5 60
  zshz_seed "$TESTDIR/elsewhere2" 9 60
  rm -rf "$TESTDIR/elsewhere1" "$TESTDIR/elsewhere2"

  ZSHZ_KEEP_DIRS=( / ) zshz --add "$TESTDIR/trigger"

  assert_eq "5" "$(zshz_rank_of "$TESTDIR/elsewhere1")" \
    "KEEP_DIRS=(/) should keep any missing entry, regardless of path"
  assert_eq "9" "$(zshz_rank_of "$TESTDIR/elsewhere2")" \
    "KEEP_DIRS=(/) should keep every missing entry"
}

test_keep_dirs_does_not_protect_prefix_sibling() {
  # The keep test is `${line%%\|*} == ${dir}/* || ${line%%\|*} == $dir',
  # so excluding `/foo' must not keep `/foobar' (same boundary as the
  # ZSHZ_EXCLUDE_DIRS pattern in `test_manual_add.zsh').
  mkdir -p "$TESTDIR/holdme" "$TESTDIR/holdmeSibling" "$TESTDIR/trigger"
  zshz_seed "$TESTDIR/holdme"        3 60
  zshz_seed "$TESTDIR/holdmeSibling" 7 60
  rm -rf "$TESTDIR/holdme" "$TESTDIR/holdmeSibling"

  ZSHZ_KEEP_DIRS=( "$TESTDIR/holdme" ) zshz --add "$TESTDIR/trigger"

  assert_eq "3" "$(zshz_rank_of "$TESTDIR/holdme")" \
    "the exact KEEP_DIRS path should survive"
  assert_eq "" "$(zshz_rank_of "$TESTDIR/holdmeSibling")" \
    "a prefix-sibling of a KEEP_DIRS entry must not be protected"
}

test_keep_dirs_with_multiple_entries_each_protects_independently() {
  # Three different KEEP_DIRS entries; each protects its own path.
  mkdir -p "$TESTDIR/k1/inner" "$TESTDIR/k2" "$TESTDIR/k3" \
           "$TESTDIR/dropme" "$TESTDIR/trigger"
  zshz_seed "$TESTDIR/k1/inner" 1 60
  zshz_seed "$TESTDIR/k2"       2 60
  zshz_seed "$TESTDIR/k3"       3 60
  zshz_seed "$TESTDIR/dropme"   9 60
  rm -rf "$TESTDIR/k1" "$TESTDIR/k2" "$TESTDIR/k3" "$TESTDIR/dropme"

  ZSHZ_KEEP_DIRS=( "$TESTDIR/k1" "$TESTDIR/k2" "$TESTDIR/k3" ) \
    zshz --add "$TESTDIR/trigger"

  assert_eq "1" "$(zshz_rank_of "$TESTDIR/k1/inner")" "k1 subtree kept"
  assert_eq "2" "$(zshz_rank_of "$TESTDIR/k2")"       "k2 exact kept"
  assert_eq "3" "$(zshz_rank_of "$TESTDIR/k3")"       "k3 exact kept"
  assert_eq "" "$(zshz_rank_of "$TESTDIR/dropme")" \
    "an entry not under any KEEP_DIRS root should still be pruned"
}

test_keep_dirs_affects_read_time_listing() {
  # `_zshz_find_matches' applies the same prune. A missing-dir entry
  # must not surface in `zshz -l' unless KEEP_DIRS protects it.
  # This pins the read-side branch (the rewrite-side branch is
  # exercised by every other test in this file via `--add').
  mkdir -p "$TESTDIR/visible" "$TESTDIR/hidden"
  zshz_seed "$TESTDIR/visible" 1 60
  zshz_seed "$TESTDIR/hidden"  1 60
  rm -rf "$TESTDIR/hidden"

  # Without KEEP_DIRS, the hidden entry is filtered from `-l'.
  local out
  out=$(zshz -l)
  assert_contains "$TESTDIR/visible" "$out" "visible entry must be listed"
  assert_not_contains "$TESTDIR/hidden" "$out" \
    "missing-dir entry must be filtered from -l"

  # With KEEP_DIRS protecting it, the hidden entry surfaces.
  out=$(ZSHZ_KEEP_DIRS=( "$TESTDIR/hidden" ) zshz -l)
  assert_contains "$TESTDIR/hidden" "$out" \
    "KEEP_DIRS-protected entry must surface in -l despite missing dir"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
