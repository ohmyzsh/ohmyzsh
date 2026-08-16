# Compatibility with legacy _Z_* environment variables.

test__Z_DATA_selects_legacy_datafile() {
  local legacy_data="$TESTDIR/legacy.z"
  mkdir -p "$TESTDIR/work"

  unset ZSHZ_DATA
  _Z_DATA="$legacy_data" zshz --add "$TESTDIR/work"

  assert_file_exists "$legacy_data"
  assert_contains "$TESTDIR/work|1|" "$(cat "$legacy_data")" "_Z_DATA should choose the legacy datafile path"
}

test__Z_CMD_defines_legacy_alias_name() {
  local out
  out=$(zsh --no-rcs -c "
    _Z_CMD=zoo
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    print -- \${aliases[zoo]:-NONE}
  ")

  assert_eq "zshz 2>&1" "$out" "_Z_CMD should define the alias under the legacy command name"
}

test__Z_MAX_SCORE_controls_aging() {
  mkdir -p "$TESTDIR/x"
  local i

  _Z_MAX_SCORE=5
  for i in {1..7}; do
    zshz --add "$TESTDIR/x"
  done

  local rank
  rank=$(zshz_rank_of "$TESTDIR/x")
  [[ -n $rank ]] || fail "rank should be present"
  (( rank < 7 )) || fail "_Z_MAX_SCORE should trigger aging before rank reaches 7, was $rank"
  (( rank > 6 )) || fail "aged rank should still stay above 6, was $rank"
}

test__Z_NO_RESOLVE_SYMLINKS_stores_link_path() {
  local target="$TESTDIR/target" link="$TESTDIR/link"
  mkdir -p "$target"
  ln -s "$target" "$link"

  _Z_NO_RESOLVE_SYMLINKS=1 zshz --add "$link"

  assert_eq "1" "$(zshz_rank_of "$link")" "_Z_NO_RESOLVE_SYMLINKS should store the symlink path"
  assert_eq "" "$(zshz_rank_of "$target")" "_Z_NO_RESOLVE_SYMLINKS should not store the resolved target"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
