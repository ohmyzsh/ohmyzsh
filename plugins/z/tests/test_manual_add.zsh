# Pin the manual-`--add' defenses in `_zshz_add_or_remove_path' (the
# block at zsh-z.plugin.zsh:210-224 that rejects $HOME and any path
# under ZSHZ_EXCLUDE_DIRS). The same checks live in `_zshz_precmd' for
# the prompt path; this set covers the user-typed `zshz --add ...'
# entry point, which bypasses precmd entirely.
#
# Pins behaviour both ways: a future "remove the redundant block"
# rewrite would change pass-3 (these tests would start failing) and a
# future "tighten the comparison" rewrite (e.g., quote-the-RHS for
# $HOME) should not change observable behaviour for any of these cases.

test_manual_add_of_HOME_is_rejected() {
  local HOME="$TESTDIR/home"
  mkdir -p "$HOME"

  zshz --add "$HOME"
  assert_eq "" "$(zshz_rank_of "$HOME")" \
    "manual --add of \$HOME should not create an entry"
}

test_manual_add_of_exact_excluded_dir_is_rejected() {
  mkdir -p "$TESTDIR/excluded"
  ZSHZ_EXCLUDE_DIRS=( "$TESTDIR/excluded" )

  zshz --add "$TESTDIR/excluded"
  assert_eq "" "$(zshz_rank_of "$TESTDIR/excluded")" \
    "manual --add of an excluded directory itself should not create an entry"
}

test_manual_add_of_subdir_of_excluded_dir_is_rejected() {
  mkdir -p "$TESTDIR/excluded/inner/deeper"
  ZSHZ_EXCLUDE_DIRS=( "$TESTDIR/excluded" )

  zshz --add "$TESTDIR/excluded/inner"
  assert_eq "" "$(zshz_rank_of "$TESTDIR/excluded/inner")" \
    "subdir of an excluded directory should not create an entry"

  zshz --add "$TESTDIR/excluded/inner/deeper"
  assert_eq "" "$(zshz_rank_of "$TESTDIR/excluded/inner/deeper")" \
    "deeper subdir of an excluded directory should not create an entry"
}

test_manual_add_of_prefix_sibling_of_excluded_is_allowed() {
  # The exclude pattern is `${exclude}|${exclude}/*' -- it matches the
  # excluded directory itself OR any subdirectory, but NOT a sibling
  # whose name happens to share the same prefix. e.g. excluding
  # `/foo' must not exclude `/foobar'.
  mkdir -p "$TESTDIR/excluded" "$TESTDIR/excludedSibling"
  ZSHZ_EXCLUDE_DIRS=( "$TESTDIR/excluded" )

  zshz --add "$TESTDIR/excludedSibling"
  assert_eq "1" "$(zshz_rank_of "$TESTDIR/excludedSibling")" \
    "prefix-sibling of an excluded dir should still be added"
}

test_manual_add_of_unrelated_path_is_added() {
  # Control: with $HOME and ZSHZ_EXCLUDE_DIRS set, an unrelated path
  # must round-trip normally so we know the rejection logic isn't
  # over-broad.
  local HOME="$TESTDIR/home"
  mkdir -p "$HOME" "$TESTDIR/excluded" "$TESTDIR/work"
  ZSHZ_EXCLUDE_DIRS=( "$TESTDIR/excluded" )

  zshz --add "$TESTDIR/work"
  assert_eq "1" "$(zshz_rank_of "$TESTDIR/work")" \
    "an unrelated path should be added even when HOME and excludes are set"
}

test_manual_add_legacy_Z_EXCLUDE_DIRS_also_rejects() {
  # The exclude check reads `${ZSHZ_EXCLUDE_DIRS:-${_Z_EXCLUDE_DIRS}}',
  # so the legacy `_Z_EXCLUDE_DIRS' should still be honoured when
  # `ZSHZ_EXCLUDE_DIRS' is unset.
  mkdir -p "$TESTDIR/excluded/inner"
  unset ZSHZ_EXCLUDE_DIRS
  _Z_EXCLUDE_DIRS=( "$TESTDIR/excluded" )

  zshz --add "$TESTDIR/excluded/inner"
  assert_eq "" "$(zshz_rank_of "$TESTDIR/excluded/inner")" \
    "legacy _Z_EXCLUDE_DIRS should still cause manual --add to skip"
}

test_manual_add_of_multiple_excludes_each_rejects() {
  # Multiple exclude entries: each independently triggers rejection.
  mkdir -p "$TESTDIR/ex1" "$TESTDIR/ex2/inner" "$TESTDIR/ex3"
  ZSHZ_EXCLUDE_DIRS=( "$TESTDIR/ex1" "$TESTDIR/ex2" "$TESTDIR/ex3" )

  zshz --add "$TESTDIR/ex1"
  zshz --add "$TESTDIR/ex2/inner"
  zshz --add "$TESTDIR/ex3"

  assert_eq "" "$(zshz_rank_of "$TESTDIR/ex1")" "first exclude entry should reject"
  assert_eq "" "$(zshz_rank_of "$TESTDIR/ex2/inner")" "second exclude entry should reject (subdir)"
  assert_eq "" "$(zshz_rank_of "$TESTDIR/ex3")" "third exclude entry should reject"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
