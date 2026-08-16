# Frecency, rank-only (-r), and time-only (-t) matching.
#
# Each test seeds the datafile with synthetic rank/time values (paths must
# exist on disk or stale-cleanup would remove them) and asserts which entry
# wins. These tests lock in the frecency calculation used by
# `_zshz_find_matches`.

test_frecency_higher_rank_wins_at_equal_time() {
  mkdir -p "$TESTDIR/t/aa" "$TESTDIR/t/bb"
  zshz_seed "$TESTDIR/t/aa" 1 60
  zshz_seed "$TESTDIR/t/bb" 100 60
  assert_eq "$TESTDIR/t/bb" "$(zshz -e t)" "higher rank wins when times are equal"
}

test_frecency_recent_wins_at_equal_rank() {
  mkdir -p "$TESTDIR/t/aa" "$TESTDIR/t/bb"
  zshz_seed "$TESTDIR/t/aa" 10 60
  zshz_seed "$TESTDIR/t/bb" 10 86400
  assert_eq "$TESTDIR/t/aa" "$(zshz -e t)" "more recent wins when ranks are equal"
}

test_frecency_high_rank_old_beats_low_rank_recent() {
  # 1000 from a day ago vs 1 from 5 minutes ago: rank dominance still wins
  mkdir -p "$TESTDIR/t/aa" "$TESTDIR/t/bb"
  zshz_seed "$TESTDIR/t/aa" 1000 86400
  zshz_seed "$TESTDIR/t/bb" 1 300
  assert_eq "$TESTDIR/t/aa" "$(zshz -e t)" "very high rank still wins despite age"
}

test_frecency_recent_low_rank_beats_old_higher_rank() {
  # rank 10 a minute ago vs rank 20 a day ago: recency wins
  mkdir -p "$TESTDIR/t/aa" "$TESTDIR/t/bb"
  zshz_seed "$TESTDIR/t/aa" 10 60
  zshz_seed "$TESTDIR/t/bb" 20 86400
  assert_eq "$TESTDIR/t/aa" "$(zshz -e t)" "moderate recency beats moderately higher old rank"
}

test_rank_match_picks_highest_rank_ignoring_time() {
  mkdir -p "$TESTDIR/t/aa" "$TESTDIR/t/bb"
  zshz_seed "$TESTDIR/t/aa" 5 60
  zshz_seed "$TESTDIR/t/bb" 10 31536000
  assert_eq "$TESTDIR/t/bb" "$(zshz -re t)" "-r should pick higher rank regardless of age"
}

test_time_match_picks_most_recent_ignoring_rank() {
  mkdir -p "$TESTDIR/t/aa" "$TESTDIR/t/bb"
  zshz_seed "$TESTDIR/t/aa" 1 60
  zshz_seed "$TESTDIR/t/bb" 100 86400
  assert_eq "$TESTDIR/t/aa" "$(zshz -te t)" "-t should pick more recent regardless of rank"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
