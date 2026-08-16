# ZSHZ_CD: substitute a custom directory-changing command (e.g. pushd).

test_jump_uses_default_cd_without_ZSHZ_CD() {
  mkdir -p "$TESTDIR/foo"
  zshz --add "$TESTDIR/foo"
  local out
  out=$(zshz foo && pwd)
  assert_eq "$TESTDIR/foo" "$out" "default jump should cd into the matched dir"
}

test_jump_uses_ZSHZ_CD_when_set() {
  mkdir -p "$TESTDIR/foo"
  zshz --add "$TESTDIR/foo"

  cd_capture() { print "captured:$1"; cd "$@" }
  ZSHZ_CD=cd_capture
  local out
  out=$(zshz foo)
  assert_contains "captured:$TESTDIR/foo" "$out" "ZSHZ_CD function should receive the target path"
}

test_ZSHZ_CD_supports_multi_word_command() {
  mkdir -p "$TESTDIR/foo"
  zshz --add "$TESTDIR/foo"

  capture_multi() { print "multi:$1:$2"; cd "$2" }
  ZSHZ_CD='capture_multi PREFIX'
  local out
  out=$(zshz foo)
  assert_contains "multi:PREFIX:$TESTDIR/foo" "$out" "ZSHZ_CD value should be word-split via \${=...}"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
