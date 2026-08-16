# Round-trip behaviour for paths containing non-ASCII characters.
#
# Three scripts represent distinct UTF-8 categories: Latin-extended
# (single-codepoint accented chars), CJK (multi-byte ideographs), and
# Cyrillic (a separate alphabet exercising any locale-dependent paths).
# Each test creates the directory on disk so the missing-directory
# prune doesn't drop the entry, then verifies add, search by ASCII or
# native substring, listing, and remove via `-x'.

test_path_with_latin_extended_round_trip() {
  local p="$TESTDIR/café/résumé"
  mkdir -p "$p"
  zshz --add "$p"
  assert_eq "1" "$(zshz_rank_of "$p")" "add should land Latin-extended path"

  local out
  out=$(zshz -e café)
  assert_eq "$p" "$out" "search by native substring should find Latin-extended path"

  local list
  list=$(zshz -l)
  assert_contains "café" "$list" "list should include Latin-extended path"

  zshz -x "$p"
  assert_eq "" "$(zshz_rank_of "$p")" "remove should clear Latin-extended path"
}

test_path_with_cjk_round_trip() {
  local p="$TESTDIR/日本語/プロジェクト"
  mkdir -p "$p"
  zshz --add "$p"
  assert_eq "1" "$(zshz_rank_of "$p")" "add should land CJK path"

  local out
  out=$(zshz -e 日本語)
  assert_eq "$p" "$out" "search by CJK substring should find CJK path"

  local list
  list=$(zshz -l)
  assert_contains "日本語" "$list" "list should include CJK path"

  zshz -x "$p"
  assert_eq "" "$(zshz_rank_of "$p")" "remove should clear CJK path"
}

test_path_with_cyrillic_round_trip() {
  local p="$TESTDIR/привет/мир"
  mkdir -p "$p"
  zshz --add "$p"
  assert_eq "1" "$(zshz_rank_of "$p")" "add should land Cyrillic path"

  local out
  out=$(zshz -e привет)
  assert_eq "$p" "$out" "search by Cyrillic substring should find Cyrillic path"

  local list
  list=$(zshz -l)
  assert_contains "привет" "$list" "list should include Cyrillic path"

  zshz -x "$p"
  assert_eq "" "$(zshz_rank_of "$p")" "remove should clear Cyrillic path"
}

test_ascii_substring_finds_path_with_unicode() {
  # Mixed ASCII / non-ASCII in the same path component, searched by
  # the ASCII portion. Confirms substring matching crosses byte
  # boundaries cleanly when the search query stays in ASCII.
  local p="$TESTDIR/proj-café-2026/notes"
  mkdir -p "$p"
  zshz --add "$p"

  local out
  out=$(zshz -e proj)
  assert_eq "$p" "$out" "ASCII query should find a path that contains non-ASCII chars elsewhere"
}

test_issue_48_cjk_echo_returns_byte_exact_path() {
  # Direct regression for https://github.com/agkozak/zsh-z/issues/48
  # — `zshz -e TW' against a path containing CJK characters used to
  # return a corrupted string (e.g. "TW4791主僣" instead of the real
  # "TW4791主包内容") because Zsh's `print -v REPLY <arg>' mangled
  # multibyte strings until late 2020. `_zshz_printv' works around
  # that by using `print -v REPLY -f %s <arg>'; if anyone simplifies
  # the helper back to the plain form, this test fails.
  local p="$TESTDIR/TW4791主包内容"
  mkdir -p "$p"
  zshz --add "$p"

  local out
  out=$(zshz -e TW)
  assert_eq "$p" "$out" \
    "z -e must return the byte-exact CJK path; issue #48 corrupted the trailing CJK chars"
}

test_common_root_line_preserves_multibyte_prefix() {
  # `_zshz_find_common_root' funnels the shared prefix through
  # `_zshz_printv -- $short' (a separate callsite from the `-e' path
  # exercised above). The "common: PATH" line in `-l' output is what
  # surfaces it; assert the prefix bytes come through verbatim.
  #
  # The plugin's common-root algorithm only emits the line when the
  # common prefix is itself one of the matched paths, so the parent
  # `プロジェクト' directory needs to be in the database too.
  local root="$TESTDIR/プロジェクト"
  local a="$root/alpha" b="$root/beta" c="$root/gamma"
  mkdir -p "$a" "$b" "$c"
  zshz --add "$root"
  zshz --add "$a"
  zshz --add "$b"
  zshz --add "$c"

  local list
  list=$(zshz -l プロジェクト)
  assert_contains "common:" "$list" \
    "list should emit a 'common:' line when matches share a prefix"
  assert_contains "$root" "$list" \
    "the multibyte common prefix must appear byte-exact in the list output"
}

test_cjk_path_with_escape_special_chars_round_trips() {
  # Combination of #48's concern (multibyte) and the
  # associative-array escape chain in `_zshz_find_matches'
  # ([:751-768]): a path that hits BOTH must survive add + search
  # without corruption.
  local p="$TESTDIR/project(主包)/notes"
  mkdir -p "$p"
  zshz --add "$p"
  assert_eq "1" "$(zshz_rank_of "$p")" "add must land path with CJK + parens"

  local out
  out=$(zshz -e 主包)
  assert_eq "$p" "$out" \
    "search by CJK substring must return byte-exact path containing escape-targeted chars"
}

test_cjk_substring_matches_at_start_middle_and_end() {
  # Substring matching that crosses byte boundaries: the multibyte
  # component sits at the start, middle, and end of three different
  # paths. Verifies the `*$fnd*' glob doesn't accidentally split on
  # byte rather than character boundaries.
  local at_start="$TESTDIR/日本/src"
  local at_middle="$TESTDIR/prj/日本/build"
  local at_end="$TESTDIR/notes/2026/日本"
  mkdir -p "$at_start" "$at_middle" "$at_end"
  zshz --add "$at_start"
  zshz --add "$at_middle"
  zshz --add "$at_end"

  local list
  list=$(zshz -l 日本)
  assert_contains "$at_start"  "$list" "CJK substring at path start should match"
  assert_contains "$at_middle" "$list" "CJK substring mid-path should match"
  assert_contains "$at_end"    "$list" "CJK substring at path end should match"
}

test_case_insensitive_mode_does_not_corrupt_cjk() {
  # `ZSHZ_CASE=ignore' lowercases both sides via `:l'. For chars
  # without a case (most CJK), `:l' is a no-op; the test pins that
  # this no-op stays a no-op rather than mangling the bytes.
  local p="$TESTDIR/日本語/notes"
  mkdir -p "$p"
  ZSHZ_CASE=ignore zshz --add "$p"

  local out
  out=$(ZSHZ_CASE=ignore zshz -e 日本語)
  assert_eq "$p" "$out" \
    "ZSHZ_CASE=ignore must not corrupt CJK chars during case folding"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
