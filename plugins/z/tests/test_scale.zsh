# Scale / smoke tests for large datafiles.
#
# Gated behind ZSHZ_HEAVY_TESTS=1 so the regular run stays fast. These
# tests exercise the read+filter+rewrite code paths against datafiles
# orders of magnitude larger than typical interactive use, to catch
# accidental quadratic blowups, memory issues, or array-handling bugs
# that only surface at scale. Aging *correctness* at the threshold is
# already covered by test_aging.zsh; this file targets behavior under
# load.
#
# Run with:  ZSHZ_HEAVY_TESTS=1 zsh tests/run.zsh 'test_large_*'

[[ -n $ZSHZ_HEAVY_TESTS ]] || return 0

# Seed $1 entries directly into $ZSHZ_DATA in a single redirected block
# (no per-entry fork; calling `zshz_seed' in a loop is much slower).
# Each entry gets a unique path under $TESTDIR/scale/dir_$i.
_seed_n_entries() {
  local n=$1 i
  local now=$EPOCHSECONDS
  {
    for ((i=1; i<=n; i++)); do
      print "$TESTDIR/scale/dir_$i|$i|$(( now - i ))"
    done
  } > "$ZSHZ_DATA"
}

test_large_datafile_list_completes() {
  local n=5000
  _seed_n_entries $n
  # Both the read-time `_zshz_find_matches' loop and the write-time
  # `_zshz_update_datafile' loop drop entries whose backing directory
  # doesn't exist. KEEP_DIRS=/ preserves them all.
  ZSHZ_KEEP_DIRS=( / )

  local out lines
  out=$(zshz -l)
  lines=$(print -r -- "$out" | wc -l)

  (( lines >= n - 100 )) || \
    fail "list output truncated; expected ~$n lines, got $lines"
}

test_large_datafile_add_preserves_entries() {
  local n=5000
  _seed_n_entries $n
  ZSHZ_KEEP_DIRS=( / )
  # Push MAX_SCORE far above the seeded sum (sum of 1..n = n*(n+1)/2 =
  # 12502500) so aging doesn't kick in here -- this test is about
  # scale-time correctness of the rewrite path, not aging arithmetic.
  ZSHZ_MAX_SCORE=99999999
  mkdir -p "$TESTDIR/new"

  zshz --add "$TESTDIR/new" || return 1

  assert_eq "1" "$(zshz_rank_of "$TESTDIR/new")" \
    "--add to a large datafile should land the new entry"
  assert_eq "1" "$(zshz_rank_of "$TESTDIR/scale/dir_1")" \
    "first seeded entry should survive --add through a large datafile"
  assert_eq "$n" "$(zshz_rank_of "$TESTDIR/scale/dir_$n")" \
    "last seeded entry should survive --add through a large datafile"
}

test_large_datafile_search_returns_a_match() {
  local n=5000
  _seed_n_entries $n
  ZSHZ_KEEP_DIRS=( / )
  # Real directory so the echo path can produce output.
  mkdir -p "$TESTDIR/scale/dir_4242"

  local out
  out=$(zshz -e dir_4242)
  assert_contains "dir_4242" "$out" \
    "search through a large datafile should find the matching entry"
}

test_large_datafile_aging_triggers_at_scale() {
  # With ranks 1..n, sum = n*(n+1)/2 -- 12502500 for n=5000, far above
  # the default MAX_SCORE of 9000. The next --add should multiply every
  # rank by 0.99. We assert this on a few sampled entries; doing so
  # across 5000 also exercises the aging loop's behavior on a real
  # large dataset.
  local n=5000
  _seed_n_entries $n
  ZSHZ_KEEP_DIRS=( / )
  # --add an existing entry so the test doesn't depend on `mkdir' for
  # the new path; we want to observe aging on entries already present.
  mkdir -p "$TESTDIR/scale/dir_1"

  zshz --add "$TESTDIR/scale/dir_1" || return 1

  # dir_1 starts at rank 1, becomes 2 after the add, then aging
  # multiplies by 0.99 -> 1.98. Allow some slack for floating-point
  # representation.
  local r1
  r1=$(zshz_rank_of "$TESTDIR/scale/dir_1")
  [[ -n $r1 ]] || fail "dir_1 should still exist after aging"
  (( r1 < 2 ))    || fail "aging should drop dir_1 below 2, was $r1"
  (( r1 > 1.9 )) || fail "aging shouldn't drop dir_1 below 1.9, was $r1"

  # dir_5000 stays at rank 5000 (it wasn't re-added), aged to 4950.
  local rN
  rN=$(zshz_rank_of "$TESTDIR/scale/dir_$n")
  (( rN < 5000 )) || fail "aging should drop dir_$n below 5000, was $rN"
  (( rN > 4940 )) || fail "aging shouldn't drop dir_$n below 4940, was $rN"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
