# Pin `_zshz_find_common_root' behaviour across input orderings and
# structures.
#
# `_zshz_find_common_root' is nested inside `zshz()' and not callable
# directly; these tests drive it through `zshz -e <query>' against
# datafiles seeded in deliberate orders. The associative-array
# iteration order in `_zshz_find_common_root' depends on insertion
# order, so seeding the same entries in different orders can exercise
# different paths through the loop. The existing
# `test_default_returns_common_root_when_one_exists' in test_uncommon.zsh
# covers a single ordering of one structure; this file pins the
# algorithm against the broader space before any tightening.
#
# Output assertions all run with default settings (ZSHZ_UNCOMMON unset),
# in which case `_zshz_output' returns the common root when one is
# found and falls back to the highest-ranked match otherwise.

test_common_root_seeded_root_first() {
  mkdir -p "$TESTDIR/croot/sub1" "$TESTDIR/croot/sub2"
  zshz_seed "$TESTDIR/croot"      1   60
  zshz_seed "$TESTDIR/croot/sub1" 100 60
  zshz_seed "$TESTDIR/croot/sub2" 50  60

  local out
  out=$(zshz -e croot)
  assert_eq "$TESTDIR/croot" "$out" \
    "common root should be returned when seeded first"
}

test_common_root_seeded_root_middle() {
  mkdir -p "$TESTDIR/croot/sub1" "$TESTDIR/croot/sub2"
  zshz_seed "$TESTDIR/croot/sub1" 100 60
  zshz_seed "$TESTDIR/croot"      1   60
  zshz_seed "$TESTDIR/croot/sub2" 50  60

  local out
  out=$(zshz -e croot)
  assert_eq "$TESTDIR/croot" "$out" \
    "common root should be returned when seeded between siblings"
}

test_common_root_seeded_root_last() {
  mkdir -p "$TESTDIR/croot/sub1" "$TESTDIR/croot/sub2"
  zshz_seed "$TESTDIR/croot/sub1" 100 60
  zshz_seed "$TESTDIR/croot/sub2" 50  60
  zshz_seed "$TESTDIR/croot"      1   60

  local out
  out=$(zshz -e croot)
  assert_eq "$TESTDIR/croot" "$out" \
    "common root should be returned when seeded last"
}

test_common_root_no_root_entry_picks_highest_ranked() {
  # No entry for the actual common ancestor `$TESTDIR/croot'; only
  # siblings are present. `_zshz_find_common_root' can't return an
  # ancestor that isn't in the input set, so the second loop should
  # find no agreement, and `_zshz_output' should fall through to the
  # highest-ranked match.
  mkdir -p "$TESTDIR/croot/sub1" "$TESTDIR/croot/sub2"
  zshz_seed "$TESTDIR/croot/sub1" 100 60
  zshz_seed "$TESTDIR/croot/sub2" 50  60

  local out
  out=$(zshz -e croot)
  assert_eq "$TESTDIR/croot/sub1" "$out" \
    "without a common-root entry, the highest-ranked sibling should win"
}

test_common_root_mixed_depth_under_one_root() {
  # Three paths, depths 1, 2, 3, all under the same root. The shortest
  # (`$TESTDIR/croot') is the common root and is in the input set, so
  # the function should pick it regardless of which is highest-ranked.
  mkdir -p "$TESTDIR/croot/a/b"
  zshz_seed "$TESTDIR/croot/a/b" 100 60
  zshz_seed "$TESTDIR/croot/a"   50  60
  zshz_seed "$TESTDIR/croot"     1   60

  local out
  out=$(zshz -e croot)
  assert_eq "$TESTDIR/croot" "$out" \
    "common root should win against deeper higher-ranked descendants"
}

test_common_root_deep_with_irrelevant_high_rank_neighbour() {
  # A high-ranked entry that doesn't match the query shouldn't enter
  # `matches' at all and shouldn't influence the common-root choice.
  mkdir -p "$TESTDIR/croot/sub1" "$TESTDIR/croot/sub2" "$TESTDIR/elsewhere"
  zshz_seed "$TESTDIR/croot"      1    60
  zshz_seed "$TESTDIR/croot/sub1" 50   60
  zshz_seed "$TESTDIR/croot/sub2" 100  60
  zshz_seed "$TESTDIR/elsewhere"  9999 60   # unrelated, high rank

  local out
  out=$(zshz -e croot)
  assert_eq "$TESTDIR/croot" "$out" \
    "high-rank non-matching entry must not perturb the common-root choice"
}

test_common_root_single_match_returns_full_path() {
  # If only one entry matches, there's no "common root" to compute --
  # the single match itself is the answer.
  mkdir -p "$TESTDIR/onlyone"
  zshz_seed "$TESTDIR/onlyone" 10 60

  local out
  out=$(zshz -e onlyone)
  assert_eq "$TESTDIR/onlyone" "$out" \
    "single match should be returned as-is"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
