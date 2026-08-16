# ZSHZ_CASE: 'smart', 'ignore', or default.
#
# `_zshz_find_matches` supports three modes:
# Default:    case-sensitive match preferred, case-insensitive as fallback.
# 'smart':   case-insensitive only if query is all lowercase.
# 'ignore':  always case-insensitive.

# Skip tests that need two paths differing only in case to coexist. macOS's
# default APFS (and HFS+) is case-insensitive, so `foo/bar' and `Foo/Bar'
# collapse to a single directory there and the case-sensitive tie-break can't
# be exercised. This is a probe rather than an $OSTYPE match because case
# sensitivity is a per-volume property, not a per-OS one. Returns 0 (skip) or
# 1 (run).
_test_skip_case_insensitive_fs() {
  local probe=$TESTDIR/.case-probe
  mkdir -p "$probe" 2>/dev/null
  local insensitive=1
  [[ -d $TESTDIR/.CASE-PROBE ]] || insensitive=0
  rmdir "$probe" 2>/dev/null
  (( insensitive )) && return 0
  return 1
}

test_case_default_falls_back_to_insensitive() {
  mkdir -p "$TESTDIR/Foo/Bar"
  zshz --add "$TESTDIR/Foo/Bar"
  local out
  out=$(zshz -e bar)
  assert_eq "$TESTDIR/Foo/Bar" "$out" "default mode should fall back to case-insensitive"
}

test_case_default_prefers_sensitive_when_both_available() {
  _test_skip_case_insensitive_fs && {
    _test_skip "case-sensitive filesystem required"
    return 0
  }
  mkdir -p "$TESTDIR/Foo/Bar" "$TESTDIR/foo/bar"
  zshz --add "$TESTDIR/Foo/Bar"
  zshz --add "$TESTDIR/foo/bar"
  local out
  out=$(zshz -e bar)
  assert_eq "$TESTDIR/foo/bar" "$out" "default mode should prefer case-sensitive match"
}

test_case_ignore_always_insensitive() {
  mkdir -p "$TESTDIR/Foo/Bar"
  zshz --add "$TESTDIR/Foo/Bar"
  ZSHZ_CASE=ignore
  local out
  out=$(zshz -e bar)
  assert_eq "$TESTDIR/Foo/Bar" "$out" "ZSHZ_CASE=ignore should match case-insensitively"
}

test_case_smart_lowercase_query_is_insensitive() {
  mkdir -p "$TESTDIR/Foo/Bar"
  zshz --add "$TESTDIR/Foo/Bar"
  ZSHZ_CASE=smart
  local out
  out=$(zshz -e bar)
  assert_eq "$TESTDIR/Foo/Bar" "$out" "smart + lowercase query should match insensitively"
}

test_case_smart_uppercase_query_is_strict() {
  mkdir -p "$TESTDIR/foo/bar"
  zshz --add "$TESTDIR/foo/bar"
  ZSHZ_CASE=smart
  local out
  out=$(zshz -e BAR 2> /dev/null)
  local rc=$?
  assert_ne "0" "$rc" "smart + uppercase query should not fall back to insensitive"
  assert_eq "" "$out" "smart + uppercase query should not match a lowercase path"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
