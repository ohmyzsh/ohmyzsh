# Aging behaviour at the `ZSHZ_MAX_SCORE` threshold, beyond what
# `test_aging.zsh` and `test_scale.zsh` already cover.
#
# `test_aging.zsh` pins the threshold transition (no aging below,
# aging above) by adding repeatedly to one path. `test_scale.zsh`
# exercises aging across thousands of entries. This file fills the
# small-but-explicit gaps:
#
#   - Aging scales *every* entry, not just the one being added.
#     A bug that aged only the added entry's rank would still pass
#     `test_aging_kicks_in_above_max_score'.
#   - Aging is a *scale-down*, not a delete: entries with rank > 1
#     survive aging at their scaled rank (they aren't accidentally
#     filtered out by the sub-1 drop check).
#   - The time field is preserved through aging.

test_aging_scales_all_existing_entries() {
  # Three pre-seeded entries plus one --add that triggers aging.
  # All three pre-seeded entries should land at 0.99 * original.
  mkdir -p "$TESTDIR/a" "$TESTDIR/b" "$TESTDIR/c" "$TESTDIR/trigger"
  zshz_seed "$TESTDIR/a" 100 60
  zshz_seed "$TESTDIR/b" 200 60
  zshz_seed "$TESTDIR/c" 300 60
  ZSHZ_MAX_SCORE=500 zshz --add "$TESTDIR/trigger"

  # Each pre-seeded rank should now be 0.99 * original. Allow ±0.5
  # for floating-point representation; the assertions below check
  # that ranks landed in the aged range, not in the unaged-or-
  # deleted range.
  local ra rb rc
  ra=$(zshz_rank_of "$TESTDIR/a")
  rb=$(zshz_rank_of "$TESTDIR/b")
  rc=$(zshz_rank_of "$TESTDIR/c")
  (( ra < 100 ))  || fail "a should have been aged below 100, was $ra"
  (( ra > 98.5 )) || fail "a should not have been aged below 98.5, was $ra"
  (( rb < 200 ))  || fail "b should have been aged below 200, was $rb"
  (( rb > 197.5 )) || fail "b should not have been aged below 197.5, was $rb"
  (( rc < 300 ))  || fail "c should have been aged below 300, was $rc"
  (( rc > 296.5 )) || fail "c should not have been aged below 296.5, was $rc"
}

test_aging_does_not_delete_entries_above_drop_threshold() {
  # Entries comfortably above rank 1 must survive aging at their
  # scaled rank, NOT be filtered out by the `rank_field < 1' drop.
  # The contrast: rank 1.0 ages to 0.99, falls below the drop
  # threshold, and is removed on the next rewrite. Rank 5 ages to
  # 4.95 -- still well above 1, must survive.
  mkdir -p "$TESTDIR/keep1" "$TESTDIR/keep2" "$TESTDIR/trigger"
  zshz_seed "$TESTDIR/keep1" 5  60
  zshz_seed "$TESTDIR/keep2" 50 60
  ZSHZ_MAX_SCORE=10 zshz --add "$TESTDIR/trigger"

  # Both must still be present (not deleted by aging).
  assert_ne "" "$(zshz_rank_of "$TESTDIR/keep1")" \
    "rank-5 entry should not be deleted by aging"
  assert_ne "" "$(zshz_rank_of "$TESTDIR/keep2")" \
    "rank-50 entry should not be deleted by aging"
}

test_aging_preserves_timestamps() {
  # The aging branch in `_zshz_update_datafile' rewrites each entry
  # as `$x|$(( 0.99 * rank[$x] ))|${time[$x]}' -- the time field is
  # passed through verbatim. A regression that touched the time
  # field during aging would surface here.
  mkdir -p "$TESTDIR/p" "$TESTDIR/trigger"
  local now=$EPOCHSECONDS
  local seeded_ts=$(( now - 12345 ))
  print "$TESTDIR/p|100|$seeded_ts" >> "$ZSHZ_DATA"

  ZSHZ_MAX_SCORE=50 zshz --add "$TESTDIR/trigger"

  # Read the time field for the seeded entry directly.
  local stored_ts
  stored_ts=$(awk -F'|' -v p="$TESTDIR/p" '$1==p { print $3 }' "$ZSHZ_DATA")
  assert_eq "$seeded_ts" "$stored_ts" \
    "time field must be preserved through aging"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
