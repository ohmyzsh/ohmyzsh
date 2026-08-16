# Legacy completion mode and ZSHZ_TRAILING_SLASH.

test_legacy_complete_returns_matches() {
  mkdir -p "$TESTDIR/foo/bar" "$TESTDIR/foo/baz" "$TESTDIR/qux"
  zshz_seed "$TESTDIR/foo/bar" 1
  zshz_seed "$TESTDIR/foo/baz" 1
  zshz_seed "$TESTDIR/qux" 1

  ZSHZ_COMPLETION=legacy
  local out
  out=$(zshz --complete foo)
  assert_contains "$TESTDIR/foo/bar" "$out" "legacy completion should include matching paths"
  assert_contains "$TESTDIR/foo/baz" "$out" "legacy completion should include all matching paths"
  assert_not_contains "$TESTDIR/qux" "$out" "legacy completion should exclude non-matches"
}

test_legacy_complete_trailing_slash_matches_directory_end() {
  mkdir -p "$TESTDIR/root/foo" "$TESTDIR/root/foobar"
  zshz_seed "$TESTDIR/root/foo" 1
  zshz_seed "$TESTDIR/root/foobar" 1

  ZSHZ_COMPLETION=legacy
  local off
  off=$(zshz --complete 'foo/')
  assert_eq "" "$off" "without TRAILING_SLASH, query ending in / should not match a path ending in foo"

  ZSHZ_TRAILING_SLASH=1
  local on
  on=$(zshz --complete 'foo/')
  assert_contains "$TESTDIR/root/foo" "$on" "TRAILING_SLASH should allow matching a directory end"
  assert_not_contains "$TESTDIR/root/foobar" "$on" "TRAILING_SLASH should not match longer sibling names"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
