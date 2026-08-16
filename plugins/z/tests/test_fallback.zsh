# Path fallback behavior when no database match exists.

test_relative_path_fallback_changes_directory() {
  mkdir -p "$TESTDIR/rel"
  cd "$TESTDIR"

  local out
  out=$(zshz rel && pwd)
  assert_eq "$TESTDIR/rel" "$out" "relative directory arguments should fall back to direct cd"
}

test_parent_relative_path_fallback_changes_directory() {
  mkdir -p "$TESTDIR/base/target" "$TESTDIR/base/from"
  cd "$TESTDIR/base/from"

  local out
  out=$(zshz ../target && pwd)
  assert_eq "$TESTDIR/base/target" "$out" "parent-relative directory arguments should fall back to direct cd"
}

test_absolute_path_fallback_changes_directory() {
  mkdir -p "$TESTDIR/abs"

  local out
  out=$(zshz "$TESTDIR/abs" && pwd)
  assert_eq "$TESTDIR/abs" "$out" "absolute directory arguments should bypass the database and cd directly"
}

test_relative_path_fallback_does_not_apply_with_echo_or_list() {
  mkdir -p "$TESTDIR/rel"
  cd "$TESTDIR"

  local out rc
  out=$(zshz -e rel 2>/dev/null)
  rc=$?
  assert_ne "0" "$rc" "-e should not use direct-path fallback"
  assert_eq "" "$out" "-e should not echo a direct-path fallback"

  out=$(zshz -l rel 2>/dev/null)
  rc=$?
  assert_ne "0" "$rc" "-l should not use direct-path fallback"
  assert_eq "" "$out" "-l should not list a direct-path fallback"
}

test_absolute_path_fallback_does_not_apply_with_echo() {
  mkdir -p "$TESTDIR/abs"

  local out rc
  out=$(zshz -e "$TESTDIR/abs" 2>/dev/null)
  rc=$?
  assert_ne "0" "$rc" "-e should skip the absolute-path fast path"
  assert_eq "" "$out" "-e should not echo a direct absolute-path fallback"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
