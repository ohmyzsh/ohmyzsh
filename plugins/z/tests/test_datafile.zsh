# Datafile robustness: malformed lines, empty file, missing file.
#
# When `zshz` loads the database, it filters entries down to the expected
# `/path|rank|time` shape. Malformed lines should be ignored quietly rather
# than crashing or polluting results.

test_malformed_lines_are_filtered() {
  mkdir -p "$TESTDIR/valid"
  # The embedded-newline case (printf %b on \n) ends up as two physical
  # lines after `${(f)...}` splitting: `$TESTDIR/embed` and `inner|9|123'.
  # Both should be rejected by the filter -- the first because it has no
  # `|rank|time' suffix, the second because it has no leading `/'.
  printf '%b' "$TESTDIR/valid|5|1700000000

random text
$TESTDIR|nope|123
no-leading-slash|5|1700000000
|5|1700000000
$TESTDIR/missingfields
$TESTDIR/trailing|5|1700000000|extra
$TESTDIR/embed\ninner|9|123
" > "$ZSHZ_DATA"
  local out
  out=$(zshz -l 2>&1)
  assert_contains "$TESTDIR/valid" "$out" "well-formed entry should be listed"
  assert_not_contains "random text" "$out" "garbage line should not appear"
  assert_not_contains "no-leading-slash" "$out" "non-absolute path should not appear"
  assert_not_contains "missingfields" "$out" "incomplete line should not appear"
  assert_not_contains "trailing" "$out" "line with extra trailing fields should not appear"
  assert_not_contains "embed" "$out" "fragments split by an embedded newline should not appear"
  assert_not_contains "inner" "$out" "fragments split by an embedded newline should not appear"
}

test_add_preserves_valid_entries_amid_malformed_ones() {
  mkdir -p "$TESTDIR/valid" "$TESTDIR/new"
  printf '%b' "$TESTDIR/valid|5|1700000000

random text
$TESTDIR|nope|123
$TESTDIR/trailing|5|1700000000|extra
$TESTDIR/embed\ninner|9|123
" > "$ZSHZ_DATA"

  zshz --add "$TESTDIR/new" || return 1

  # The newly-added entry must land...
  assert_eq "1" "$(zshz_rank_of "$TESTDIR/new")" "--add should land despite malformed neighbors"
  # ...and the valid entry must survive the rewrite. The pre-existing
  # rank was 5; --add bumps existing entries by 1 only when the same
  # path is re-added, so the survivor's rank should still be 5.
  assert_eq "5" "$(zshz_rank_of "$TESTDIR/valid")" "valid entry should survive a rewrite past malformed lines"

  # Garbage lines should be gone from the datafile after the rewrite.
  local dump
  dump=$(zshz_dump)
  assert_not_contains "random text" "$dump" "garbage line should be dropped on rewrite"
  assert_not_contains "trailing" "$dump" "trailing-junk line should be dropped on rewrite"
  assert_not_contains "embed" "$dump" "embedded-newline fragment should be dropped on rewrite"
}

test_malformed_datafile_does_not_break_add() {
  cat > "$ZSHZ_DATA" <<EOF
total garbage
more garbage
EOF
  zshz --add "$TESTDIR" || return 1
  assert_eq "1" "$(zshz_rank_of "$TESTDIR")" "--add should still work despite malformed prior content"
}

test_empty_datafile() {
  : > "$ZSHZ_DATA"
  zshz --add "$TESTDIR" || return 1
  assert_eq "1" "$(zshz_rank_of "$TESTDIR")" "add to empty datafile should create the entry"
}

test_missing_datafile_is_created() {
  rm -f "$ZSHZ_DATA"
  zshz --add "$TESTDIR" || return 1
  assert_file_exists "$ZSHZ_DATA"
  assert_eq "1" "$(zshz_rank_of "$TESTDIR")" "add when datafile missing should create and populate it"
}

test_list_on_missing_datafile_is_clean_and_empty() {
  # Read-only operations on a never-created datafile must not error,
  # write to stderr, or leave the shell in a bad state. The plugin
  # auto-creates the datafile (and its parent directory) on every
  # zshz invocation, so the file should exist after the call even
  # though no entry has been added.
  rm -f "$ZSHZ_DATA"
  local out
  out=$(zshz -l)
  assert_eq "" "$out" "list on missing datafile should produce no output"
  assert_file_exists "$ZSHZ_DATA"
}

test_search_on_missing_datafile_matches_nothing() {
  rm -f "$ZSHZ_DATA"
  local out
  out=$(zshz nothingmatchesthis)
  assert_eq "" "$out" "search on missing datafile should match nothing"
}

test_remove_on_missing_datafile_does_not_crash() {
  # `zshz -x' on a missing datafile must not crash. It returns
  # non-zero because there's nothing to remove, but stderr must be
  # clean (the runner fails on any stderr).
  rm -f "$ZSHZ_DATA"
  zshz -x /tmp/never-added
  return 0
}

test_list_on_zero_byte_datafile_is_clean_and_empty() {
  : > "$ZSHZ_DATA"
  local out
  out=$(zshz -l)
  assert_eq "" "$out" "list on zero-byte datafile should produce no output"
}

test_whitespace_only_datafile_is_treated_as_empty() {
  # Newlines without any line content -- the `${(f)...}` split
  # produces empty array elements, and the malformed-line filter
  # discards them. --add should still work; -l should be empty.
  printf '\n\n\n' > "$ZSHZ_DATA"
  zshz --add "$TESTDIR" || return 1
  assert_eq "1" "$(zshz_rank_of "$TESTDIR")" "whitespace-only datafile should not block --add"
}

test_precmd_on_missing_datafile_creates_and_populates() {
  rm -f "$ZSHZ_DATA"
  mkdir -p "$TESTDIR/work"
  cd "$TESTDIR/work"
  _zshz_precmd
  _wait_for_add "$TESTDIR/work"
  assert_eq "1" "$(zshz_rank_of "$TESTDIR/work")" "precmd should create datafile and add PWD"
}

test_ZSHZ_DATA_without_directory_prints_error_and_exits() {
  local out
  out=$(zshz_in_fresh_shell '
    ZSHZ_DATA=barefile zshz -l && print SENTINEL
  ' 2>&1)

  assert_contains "ERROR: You configured a custom Zsh-z datafile (barefile), but have not specified its directory." "$out" "bare filename should be rejected"
  assert_not_contains "SENTINEL" "$out" "zshz should return non-zero on misconfigured datafile"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:

test_ZSHZ_DATA_directory_prints_error_and_exits() {
  mkdir -p "$TESTDIR/data-dir"
  local out
  out=$(zshz_in_fresh_shell "
    ZSHZ_DATA='$TESTDIR/data-dir' zshz -l && print SENTINEL
  " 2>&1)

  assert_contains "ERROR: Zsh-z's datafile ($TESTDIR/data-dir) is a directory." "$out" "directory datafile should be rejected"
  assert_not_contains "SENTINEL" "$out" "zshz should return non-zero on misconfigured datafile"
}
