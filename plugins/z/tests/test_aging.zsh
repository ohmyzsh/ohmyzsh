# Aging behavior at the ZSHZ_MAX_SCORE threshold.
#
# `_zshz_update_datafile` ages the database once the total stored rank exceeds
# `ZSHZ_MAX_SCORE`, multiplying each stored rank by 0.99. That threshold
# transition is easy to break with off-by-one or boolean errors.

test_no_aging_below_max_score() {
  mkdir -p "$TESTDIR/x"
  ZSHZ_MAX_SCORE=1000
  local i
  for i in {1..5}; do zshz --add "$TESTDIR/x"; done
  assert_eq "5" "$(zshz_rank_of "$TESTDIR/x")" "rank should be exact integer below threshold"
}

test_aging_kicks_in_above_max_score() {
  mkdir -p "$TESTDIR/x"
  ZSHZ_MAX_SCORE=5
  # 7 sequential adds with MAX_SCORE=5:
  #   adds 1..6: count of pre-existing ranks (0..5) never exceeds 5, stored
  #              rank ends at 6
  #   add 7: count=6 > 5 triggers aging, stored rank = 0.99 * 7 = 6.93
  local i
  for i in {1..7}; do zshz --add "$TESTDIR/x"; done

  local rank
  rank=$(zshz_rank_of "$TESTDIR/x")
  [[ -n $rank ]] || fail "rank should be present"
  (( rank < 7 )) || fail "rank should be < 7 after aging, was $rank"
  (( rank > 6 )) || fail "rank should be > 6 after aging, was $rank"
}

test_aging_drops_entries_below_rank_1() {
  # Entries whose stored rank is already below 1 are skipped when
  # `_zshz_update_datafile` rewrites the datafile. Seed an entry with rank 0.5
  # directly and trigger a write.
  mkdir -p "$TESTDIR/keep" "$TESTDIR/decayed"
  zshz_seed "$TESTDIR/keep" 10
  zshz_seed "$TESTDIR/decayed" 0.5
  zshz --add "$TESTDIR/keep"
  assert_eq "" "$(zshz_rank_of "$TESTDIR/decayed")" "entry with rank<1 should be dropped on write"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
