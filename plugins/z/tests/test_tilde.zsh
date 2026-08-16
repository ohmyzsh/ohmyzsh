# ZSHZ_TILDE: display $HOME as ~ in user-facing output (-l, -e).
#
# Each test overrides HOME locally so we don't pollute the real home.

test_tilde_replaces_home_in_list_output() {
  local HOME="$TESTDIR"
  mkdir -p "$HOME/sub"
  zshz --add "$HOME/sub"
  ZSHZ_TILDE=1
  local out
  out=$(zshz -l)
  assert_contains "~/sub" "$out" "ZSHZ_TILDE=1 should display ~ for HOME prefix in -l"
  assert_not_contains "$HOME/sub" "$out" "raw HOME path should not appear when TILDE is on"
}

test_tilde_off_shows_full_home_path() {
  local HOME="$TESTDIR"
  mkdir -p "$HOME/sub"
  zshz --add "$HOME/sub"
  local out
  out=$(zshz -l)
  assert_contains "$HOME/sub" "$out" "without TILDE, full HOME path should be shown"
}

test_tilde_in_echo_output() {
  local HOME="$TESTDIR"
  mkdir -p "$HOME/foo"
  zshz --add "$HOME/foo"
  ZSHZ_TILDE=1
  local out
  out=$(zshz -e foo)
  assert_eq "~/foo" "$out" "-e with TILDE should print ~ form"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
