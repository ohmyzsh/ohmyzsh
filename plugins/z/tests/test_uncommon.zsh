# ZSHZ_UNCOMMON: shrink the chosen destination to the shortest level that still
# preserves how many times the search pattern appears in the path. Distinct
# from the default behavior, which prefers a shared common root when one exists.

test_uncommon_shrinks_to_keep_pattern_count() {
  # /foo/bar/foo/bar contains "foo" twice; with query "foo", UNCOMMON should
  # shrink to /foo/bar/foo (the shortest ancestor that still has both "foo"s).
  mkdir -p "$TESTDIR/foo/bar/foo/bar"
  zshz --add "$TESTDIR/foo/bar/foo/bar"
  ZSHZ_UNCOMMON=1
  local out
  out=$(zshz -e foo)
  assert_eq "$TESTDIR/foo/bar/foo" "$out" "UNCOMMON should keep both 'foo' occurrences"
}

test_uncommon_trim_terminates_at_root() {
  # Regression: with ZSHZ_UNCOMMON=1 and `/' in the database, `z -e /' trimmed
  # the destination down to `/' and then spun forever -- `${cd:h}' of `/' is
  # `/', so the trim made no progress while the loop's stop condition never
  # flipped. Run the call in a backgrounded subshell behind a watchdog so a
  # regression fails this test by timeout instead of hanging the whole suite.
  ZSHZ_UNCOMMON=1
  zshz_seed '/' 5

  local outfile="$TESTDIR/uncommon_root.out"
  ( zshz -e / > "$outfile" 2>&1 ) &
  local worker=$!
  ( sleep 10; kill -9 $worker 2> /dev/null ) &
  local watchdog=$!

  if wait $worker; then
    kill $watchdog 2> /dev/null   # cancel the watchdog; the call finished
    assert_eq '/' "$(< "$outfile")" "z -e / under UNCOMMON should return the root match"
  else
    fail "z -e / under ZSHZ_UNCOMMON did not terminate within the watchdog window"
    return 1
  fi
}

test_uncommon_case_sensitive_winner_trims_case_sensitively() {
  # Regression: ZSHZ[CASE_INSENSITIVE] was set during the scan by any leading
  # case-insensitive candidate, even when a case-sensitive match ultimately
  # won. Under ZSHZ_UNCOMMON that stale flag forced the trim through the
  # case-insensitive branch, shortening by the wrong amount.
  #
  # Here "$TESTDIR/foo/Foo" wins case-sensitively for the query `foo', while
  # "$TESTDIR/FOO" is a case-insensitive-only decoy that used to set the flag.
  # The correct, case-sensitive trim drops the trailing "Foo" (it does not
  # contain `foo') and yields "$TESTDIR/foo"; the buggy case-insensitive trim
  # would keep the whole "$TESTDIR/foo/Foo".
  _test_skip_case_insensitive_fs && {
    _test_skip "case-sensitive filesystem required"
    return 0
  }
  mkdir -p "$TESTDIR/foo/Foo" "$TESTDIR/FOO"
  zshz --add "$TESTDIR/foo/Foo"
  zshz --add "$TESTDIR/FOO"
  ZSHZ_UNCOMMON=1
  local out
  out=$(zshz -e foo)
  assert_eq "$TESTDIR/foo" "$out" \
      "a case-sensitive winner must be trimmed by the case-sensitive rule"
}

test_default_with_single_match_returns_full_path() {
  mkdir -p "$TESTDIR/foo/bar/foo/bar"
  zshz --add "$TESTDIR/foo/bar/foo/bar"
  local out
  out=$(zshz -e foo)
  assert_eq "$TESTDIR/foo/bar/foo/bar" "$out" "default with single match should return the full path"
}

test_default_returns_common_root_when_one_exists() {
  mkdir -p "$TESTDIR/cr/aaa" "$TESTDIR/cr/bbb"
  zshz_seed "$TESTDIR/cr" 1 60
  zshz_seed "$TESTDIR/cr/aaa" 100 60
  zshz_seed "$TESTDIR/cr/bbb" 50 60
  local out
  out=$(zshz -e cr)
  assert_eq "$TESTDIR/cr" "$out" "default should pick the common-root entry over the highest-rank child"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
