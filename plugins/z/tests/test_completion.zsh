# Frecent completion ordering (the default ZSHZ_COMPLETION=frecent path).

test_completion_orders_near_equal_ranks_by_value() {
  # Two ranks share an integer part but have fractional tails of unequal
  # width: 100.5 > 100.25. The completion arm builds an integer sort key
  # (`rank * 100', decimal dropped) precisely because a raw-float numeric
  # sort compares the fractional digit-runs "5" vs "25" and would wrongly
  # put 100.25 first. `-r --complete' uses the stored ranks verbatim, so the
  # ordering is pinned to exact values rather than a computed frecency.
  mkdir -p "$TESTDIR/rankcmp/aaa" "$TESTDIR/rankcmp/bbb"
  zshz_seed "$TESTDIR/rankcmp/aaa" 100.5
  zshz_seed "$TESTDIR/rankcmp/bbb" 100.25

  local out
  local -a lines
  out=$(zshz -r --complete rankcmp)
  lines=( ${(f)out} )
  assert_contains "$TESTDIR/rankcmp/aaa" "$lines[1]" \
    "completion must list the higher-ranked (100.5) path first"
  assert_contains "$TESTDIR/rankcmp/bbb" "$lines[2]" \
    "completion must list the lower-ranked (100.25) path second"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
