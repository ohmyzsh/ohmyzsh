# Realpath-resolution edge cases for `--add' and `-x'.
#
# `_zshz_add_or_remove_path' funnels paths through `:A' (resolve
# symlinks + dot/dot-dot) when symlink resolution is on, and through
# `:a' (resolve dot/dot-dot only) when `ZSHZ_NO_RESOLVE_SYMLINKS=1'.
# These tests cover the cases `test_symlinks.zsh' doesn't reach:
#
#   - Two distinct symlinks resolving to the same target. Adding
#     through one and removing through the other should round-trip.
#   - Adding through a symlink and removing through the target
#     directly (and vice versa).
#   - Chained symlinks (link -> link -> target).
#   - Paths containing `..' traversal.
#   - The negative case under `ZSHZ_NO_RESOLVE_SYMLINKS=1', where two
#     symlinks to the same target are *not* the same key.

test_two_symlinks_to_same_target_share_a_db_entry() {
  _test_skip_no_symlinks && { print "skip: filesystem has no resolvable symlinks"; return 0 }
  # Default mode resolves symlinks. Adding through link1 and removing
  # through link2 should both refer to the same canonical entry.
  local target="$TESTDIR/target/inner"
  mkdir -p "$target"
  ln -s "$TESTDIR/target" "$TESTDIR/link1"
  ln -s "$TESTDIR/target" "$TESTDIR/link2"

  zshz --add "$TESTDIR/link1/inner"
  assert_eq "1" "$(zshz_rank_of "$target")" \
    "--add via link1 should store the resolved target"

  zshz -x "$TESTDIR/link2/inner"
  assert_eq "" "$(zshz_rank_of "$target")" \
    "-x via link2 should remove the entry added via link1"
}

test_add_via_symlink_remove_via_target() {
  _test_skip_no_symlinks && { print "skip: filesystem has no resolvable symlinks"; return 0 }
  local target="$TESTDIR/target/inner"
  mkdir -p "$target"
  ln -s "$TESTDIR/target" "$TESTDIR/link"

  zshz --add "$TESTDIR/link/inner"
  zshz -x "$target"
  assert_eq "" "$(zshz_rank_of "$target")" \
    "-x via target path should remove the entry added via symlink"
}

test_add_via_target_remove_via_symlink() {
  _test_skip_no_symlinks && { print "skip: filesystem has no resolvable symlinks"; return 0 }
  local target="$TESTDIR/target/inner"
  mkdir -p "$target"
  ln -s "$TESTDIR/target" "$TESTDIR/link"

  zshz --add "$target"
  zshz -x "$TESTDIR/link/inner"
  assert_eq "" "$(zshz_rank_of "$target")" \
    "-x via symlink should remove the entry added via target"
}

test_chained_symlinks_resolve_to_final_target() {
  _test_skip_no_symlinks && { print "skip: filesystem has no resolvable symlinks"; return 0 }
  # link_outer -> link_inner -> target. `:A' walks the whole chain.
  local target="$TESTDIR/target/dest"
  mkdir -p "$target"
  ln -s "$TESTDIR/target" "$TESTDIR/link_inner"
  ln -s "$TESTDIR/link_inner" "$TESTDIR/link_outer"

  zshz --add "$TESTDIR/link_outer/dest"
  assert_eq "1" "$(zshz_rank_of "$target")" \
    "chained symlinks should resolve to the final target"
}

test_dotdot_traversal_is_canonicalised() {
  # `:A' resolves `..' as well as symlinks. `--add foo/../foo/bar'
  # should land in the database as `foo/bar'.
  mkdir -p "$TESTDIR/foo/bar"
  zshz --add "$TESTDIR/foo/../foo/bar"

  assert_eq "1" "$(zshz_rank_of "$TESTDIR/foo/bar")" \
    "dot-dot traversal should be collapsed in the stored path"
  # The literal traversal form must NOT appear in the database.
  local dump
  dump=$(zshz_dump)
  assert_not_contains ".." "$dump" \
    "stored entry should not preserve dot-dot segments"
}

test_remove_deleted_dir_via_symlinked_parent() {
  _test_skip_no_symlinks && { print "skip: filesystem has no resolvable symlinks"; return 0 }
  # The removal target no longer needs to exist, but the symlinks in
  # whatever prefix of it *does* exist must still resolve -- otherwise an
  # entry added through a symlink could not be removed by the same name
  # once its directory is deleted. `_zshz_realpath' resolves the deepest
  # existing ancestor with `:A' and carries the missing tail verbatim,
  # which is also what `:A' itself does with a missing (non-top-level)
  # tail.
  local target="$TESTDIR/target/inner"
  mkdir -p "$target"
  ln -s "$TESTDIR/target" "$TESTDIR/link"

  zshz --add "$TESTDIR/link/inner"   # Stored as .../target/inner
  rm -rf "$target"

  zshz -x "$TESTDIR/link/inner" || return 1
  assert_eq "" "$(zshz_rank_of "$TESTDIR/target/inner")" \
    "-x via symlink should remove the stale entry for the deleted target"
}

test_no_resolve_keeps_two_symlinks_distinct() {
  # Negative-of-the-headline-case: with NO_RESOLVE, `link1' and
  # `link2' are two different keys even when they share a target.
  # Removing via link2 must NOT remove the entry added via link1.
  local target="$TESTDIR/target/inner"
  mkdir -p "$target"
  ln -s "$TESTDIR/target" "$TESTDIR/link1"
  ln -s "$TESTDIR/target" "$TESTDIR/link2"

  ZSHZ_NO_RESOLVE_SYMLINKS=1 zshz --add "$TESTDIR/link1/inner"
  ZSHZ_NO_RESOLVE_SYMLINKS=1 zshz -x "$TESTDIR/link2/inner"

  assert_eq "1" "$(zshz_rank_of "$TESTDIR/link1/inner")" \
    "NO_RESOLVE: -x via link2 should not remove the link1 entry"
  assert_eq "" "$(zshz_rank_of "$TESTDIR/link2/inner")" \
    "NO_RESOLVE: link2 entry should never have been written"

  # Removing via the same path that added it does work, restoring
  # the round-trip property even under NO_RESOLVE.
  ZSHZ_NO_RESOLVE_SYMLINKS=1 zshz -x "$TESTDIR/link1/inner"
  assert_eq "" "$(zshz_rank_of "$TESTDIR/link1/inner")" \
    "NO_RESOLVE: -x via link1 should remove the link1 entry"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
