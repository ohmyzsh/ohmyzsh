# ZSHZ_ECHO: print the destination path after a successful jump.

test_echo_off_no_print_on_jump() {
  mkdir -p "$TESTDIR/foo"
  zshz --add "$TESTDIR/foo"
  local out
  out=$(zshz foo)
  assert_eq "" "$out" "without ZSHZ_ECHO, jump should produce no output"
}

test_echo_prints_destination_path() {
  mkdir -p "$TESTDIR/foo"
  zshz --add "$TESTDIR/foo"
  ZSHZ_ECHO=1
  local out
  out=$(zshz foo)
  assert_eq "$TESTDIR/foo" "$out" "ZSHZ_ECHO=1 should print path after jump"
}

test_echo_combined_with_tilde() {
  local HOME="$TESTDIR"
  mkdir -p "$HOME/foo"
  zshz --add "$HOME/foo"
  ZSHZ_ECHO=1
  ZSHZ_TILDE=1
  local out
  out=$(zshz foo)
  assert_eq "~/foo" "$out" "ECHO + TILDE should print ~ form"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
