# The -c option: restrict matches to subdirectories of $PWD.
#
# The `-c` path prefixes the query with "$PWD " and then matches only from the
# start of candidate paths, so results must stay within the current subtree.

test_c_flag_picks_match_under_pwd() {
  mkdir -p "$TESTDIR/here/sub" "$TESTDIR/elsewhere/sub"
  zshz --add "$TESTDIR/here/sub"
  zshz --add "$TESTDIR/elsewhere/sub"

  cd "$TESTDIR/here"
  local out
  out=$(zshz -ce sub)
  assert_eq "$TESTDIR/here/sub" "$out" "-c should pick the match inside PWD subtree"
}

test_c_flag_excludes_paths_outside_pwd() {
  mkdir -p "$TESTDIR/here" "$TESTDIR/elsewhere/sub"
  zshz --add "$TESTDIR/elsewhere/sub"

  cd "$TESTDIR/here"
  local out
  out=$(zshz -ce sub 2> /dev/null)
  local rc=$?
  assert_ne "0" "$rc" "-c should not match outside PWD subtree"
  assert_eq "" "$out" "no output when nothing under PWD matches"
}

# A mirrored tree (e.g. `rsync --relative' to a backup root) stores paths that
# embed $PWD as an interior substring. The -c option must anchor its pattern at
# the start of each candidate path, or such mirrors slip through.

test_c_flag_excludes_mirror_embedding_pwd() {
  mkdir -p "$TESTDIR/projects" "$TESTDIR/backup$TESTDIR/projects/api"
  zshz --add "$TESTDIR/backup$TESTDIR/projects/api"

  cd "$TESTDIR/projects"
  local out
  out=$(zshz -ce api 2> /dev/null)
  local rc=$?
  assert_ne "0" "$rc" "-c should not match a mirror that embeds PWD mid-path"
  assert_eq "" "$out" "no output when the only candidate embeds PWD mid-path"
}

test_c_flag_prefers_real_subdir_over_higher_ranked_mirror() {
  mkdir -p "$TESTDIR/projects/api" "$TESTDIR/backup$TESTDIR/projects/api"
  zshz --add "$TESTDIR/projects/api"
  # Give the mirror the higher rank: anchoring, not frecency, must exclude it
  local i
  for i in 1 2 3; do
    zshz --add "$TESTDIR/backup$TESTDIR/projects/api"
  done

  cd "$TESTDIR/projects"
  local out
  out=$(zshz -ce api)
  assert_eq "$TESTDIR/projects/api" "$out" \
      "-c should pick the real subdirectory, not a higher-ranked mirror"
}

# At the root, every path is a subdirectory of $PWD, so -c has nothing to
# exclude and must behave as a plain query. No "$PWD " prefix is prepended
# there, so anchoring would apply to the bare query -- and no absolute path
# begins with `api', which made `z -c' from `/' match nothing at all.

test_c_flag_at_root_matches_like_a_plain_query() {
  mkdir -p "$TESTDIR/projects/api"
  zshz --add "$TESTDIR/projects/api"

  cd /
  local out rc
  out=$(zshz -ce api)
  rc=$?
  assert_eq "0" "$rc" "-c from / should find a match"
  assert_eq "$TESTDIR/projects/api" "$out" \
      "-c from / should behave like a plain query, not exclude everything"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
