# Symlink add/remove parity.
#
# `--add` and `-x` should treat the same symlink path the same way: whatever
# `--add foo/link` stored, `-x foo/link` should remove. This must hold both
# when symlinks are resolved (default) and when ZSHZ_NO_RESOLVE_SYMLINKS=1.

test_symlink_add_remove_parity_default() {
  local target="$TESTDIR/target" link="$TESTDIR/link"
  mkdir -p "$target"
  ln -s "$target" "$link"

  zshz --add "$link"
  assert_ne "" "$(zshz_dump)" "datafile should have an entry after --add"

  zshz -x "$link"
  assert_eq "" "$(zshz_dump)" "datafile should be empty after -x on same symlink"
}

test_symlink_add_remove_parity_no_resolve() {
  local target="$TESTDIR/target" link="$TESTDIR/link"
  mkdir -p "$target"
  ln -s "$target" "$link"

  ZSHZ_NO_RESOLVE_SYMLINKS=1 zshz --add "$link"
  assert_eq "1" "$(zshz_rank_of "$link")" "with NO_RESOLVE, link path itself should be stored"

  ZSHZ_NO_RESOLVE_SYMLINKS=1 zshz -x "$link"
  assert_eq "" "$(zshz_rank_of "$link")" "with NO_RESOLVE, -x on link should remove it"
}

test_symlink_add_default_stores_resolved_target() {
  _test_skip_no_symlinks && { print "skip: filesystem has no resolvable symlinks"; return 0 }
  local target="$TESTDIR/target" link="$TESTDIR/link"
  mkdir -p "$target"
  ln -s "$target" "$link"

  zshz --add "$link"
  assert_eq "1" "$(zshz_rank_of "$target")" "default mode should store the resolved target"
  assert_eq "" "$(zshz_rank_of "$link")" "default mode should not store the symlink path"
}

test_symlink_add_no_resolve_does_not_store_target() {
  local target="$TESTDIR/target" link="$TESTDIR/link"
  mkdir -p "$target"
  ln -s "$target" "$link"

  ZSHZ_NO_RESOLVE_SYMLINKS=1 zshz --add "$link"
  assert_eq "" "$(zshz_rank_of "$target")" "NO_RESOLVE should not silently store the resolved target"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
