# Listing output and ordering semantics.

test_no_args_matches_list_output() {
  mkdir -p "$TESTDIR/a" "$TESTDIR/b"
  zshz_seed "$TESTDIR/a" 5 60
  zshz_seed "$TESTDIR/b" 10 120

  # Each invocation caches its own $EPOCHSECONDS, so if the clock ticks
  # between the two captures every frecency rank drifts by one part in
  # ~10^4 and the byte comparison fails -- seen on Cygwin CI, where the
  # two command-substitution forks are slow. Retry only when a tick
  # landed inside the capture window; a genuine behavioral difference
  # fails on every attempt.
  local list no_args before
  integer attempt
  for attempt in 1 2 3; do
    before=$EPOCHSECONDS
    list=$(zshz -l)
    no_args=$(zshz)
    [[ $list == "$no_args" || $EPOCHSECONDS == $before ]] && break
  done
  assert_eq "$list" "$no_args" "calling zshz with no args should behave like -l"
}

test_list_rank_and_time_modes_order_entries() {
  mkdir -p "$TESTDIR/a" "$TESTDIR/b"
  zshz_seed "$TESTDIR/a" 5 60
  zshz_seed "$TESTDIR/b" 10 120

  local rank_out
  local -a rank_lines
  rank_out=$(zshz -lr)
  rank_lines=( ${(f)rank_out} )
  assert_contains "$TESTDIR/a" "$rank_lines[1]" "-lr should list the lower-rank entry first"
  assert_contains "$TESTDIR/b" "$rank_lines[2]" "-lr should list the higher-rank entry second"

  local time_out
  local -a time_lines
  time_out=$(zshz -lt)
  time_lines=( ${(f)time_out} )
  assert_contains "$TESTDIR/b" "$time_lines[1]" "-lt should list the older entry first"
  assert_contains "$TESTDIR/a" "$time_lines[2]" "-lt should list the newer entry second"
}

test_lt_rank_longer_than_ten_chars_not_truncated_bare_list() {
  # A `-t' rank is (visit time - now): sign + 10 digits once the time field
  # sits more than ~31.7 years in the past, as a zeroed or hand-imported
  # field does. The formatters used to right-pad with a bare `${(r:10:)}',
  # which *truncates* an 11-character rank to 10 -- misprinting the figure
  # and making the entry sort as if it were far newer than it is. This
  # exercises the bare `z -lt' fast path.
  local ancient="$TESTDIR/ancient" oldish="$TESTDIR/oldish"
  mkdir -p "$ancient" "$oldish"
  zshz_seed "$ancient" 1 "$EPOCHSECONDS"   # Time field (about) 0
  zshz_seed "$oldish" 1 900000000          # A rank of exactly 10 characters

  local out rank_token
  local -a out_lines
  out=$(zshz -lt)
  out_lines=( ${${(f)out}:#common:*} )   # Entry lines only

  assert_contains "$ancient" "$out_lines[1]" \
    "-lt should list the ancient entry first"
  assert_contains "$oldish" "$out_lines[2]" \
    "-lt should list the merely old entry second"
  rank_token=${${=out_lines[1]}[1]}
  assert_eq "11" "${#rank_token}" \
    "an 11-character -t rank should print untruncated"
}

test_lt_rank_longer_than_ten_chars_not_truncated_query_list() {
  # Same as the bare-list test above, but with a query, so the listing goes
  # through `_zshz_output' -- the general formatter the fast path mirrors.
  local ancient="$TESTDIR/ancient" oldish="$TESTDIR/oldish"
  mkdir -p "$ancient" "$oldish"
  zshz_seed "$ancient" 1 "$EPOCHSECONDS"
  zshz_seed "$oldish" 1 900000000

  local out rank_token
  local -a out_lines
  out=$(zshz -lt i)                      # `i' matches both entries
  out_lines=( ${${(f)out}:#common:*} )

  assert_contains "$ancient" "$out_lines[1]" \
    "-lt with a query should list the ancient entry first"
  assert_contains "$oldish" "$out_lines[2]" \
    "-lt with a query should list the merely old entry second"
  rank_token=${${=out_lines[1]}[1]}
  assert_eq "11" "${#rank_token}" \
    "an 11-character -t rank should print untruncated in the general formatter"
}

test_list_prints_common_root_line() {
  mkdir -p "$TESTDIR/foo" "$TESTDIR/foo/bar"
  zshz_seed "$TESTDIR/foo" 1
  zshz_seed "$TESTDIR/foo/bar" 2

  local out
  local -a lines
  out=$(zshz -l foo)
  lines=( ${(f)out} )
  assert_contains "common:" "$lines[1]" "-l should print a common-root summary when multiple matches share one"
  assert_contains "$TESTDIR/foo" "$lines[1]" "common-root summary should show the shared root"
}
test_zero_rank_entry_does_not_create_phantom_common_root() {
  # Rank-0 entries are hidden from listings, but the general formatter used
  # to include them when computing the `common:' summary, so `z -lr proj'
  # could print a root that the visible entries do not share -- while bare
  # `z -lr' (the fast path, which drops rank-0 entries before looking for a
  # root) printed none. Both formatters must describe only the entries they
  # actually list.
  mkdir -p "$TESTDIR/proj/src" "$TESTDIR/proj/docs"
  zshz_seed "$TESTDIR/proj" 0        # Hidden from the listing
  zshz_seed "$TESTDIR/proj/src" 3
  zshz_seed "$TESTDIR/proj/docs" 4

  local out
  local -a out_lines
  out=$(zshz -lr proj)
  out_lines=( ${(f)out} )
  assert_not_contains "common:" "$out" \
    "-lr with a query must not print a root belonging only to a hidden rank-0 entry"
  assert_eq "2" "${#out_lines}" "only the two ranked entries should be listed"
  assert_contains "$TESTDIR/proj/src" "$out" "src should be listed"
  assert_contains "$TESTDIR/proj/docs" "$out" "docs should be listed"

  # And the bare fast path must agree with the query form.
  out=$(zshz -lr)
  assert_not_contains "common:" "$out" \
    "bare -lr must not print a root belonging only to a hidden rank-0 entry"
}

test_bare_list_prints_common_root_line() {
  # Positive parity check for the fast path: when every listed entry is
  # ranked and one of them is the ancestor of the rest, bare `z -l' must
  # print the same `common:' summary the query form does (the query form's
  # half is test_list_prints_common_root_line above).
  mkdir -p "$TESTDIR/foo/bar"
  zshz_seed "$TESTDIR/foo" 1
  zshz_seed "$TESTDIR/foo/bar" 2

  local out
  local -a out_lines
  out=$(zshz -l)
  out_lines=( ${(f)out} )
  assert_contains "common:" "$out_lines[1]" \
    "bare -l should print a common-root summary when one entry roots the rest"
  assert_contains "$TESTDIR/foo" "$out_lines[1]" \
    "bare -l common-root summary should show the shared root"
}

test_list_with_query_does_not_change_directory() {
  mkdir -p "$TESTDIR/proj/sub" "$TESTDIR/lone"
  zshz_seed "$TESTDIR/proj" 10
  zshz_seed "$TESTDIR/proj/sub" 5
  zshz_seed "$TESTDIR/lone" 3

  # Run -l in the current shell, not inside a `$( )' capture: the regression
  # this guards against (a REPLY value leaking out of _zshz_output into the
  # jump block) moves the calling shell, and a command substitution subshell
  # can never observe that.
  cd "$TESTDIR"
  local before=$PWD

  # Multiple matches sharing a common root
  zshz -l proj > /dev/null
  assert_eq "$before" "$PWD" "-l with a query must not change directory when matches share a common root"

  # A single match -- its own common root, the everyday trigger
  zshz -l lone > /dev/null
  assert_eq "$before" "$PWD" "-l with a single match must not change directory"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
