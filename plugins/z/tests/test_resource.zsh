# Re-sourcing safety and Tab-binding behavior.
#
# When the plugin is sourced, it captures the current Tab binding into
# ZSHZ[TAB_BINDING] so its own widget can chain to it. If sourced a second
# time it must NOT recapture, or it would record its own widget name and
# cause infinite recursion when Tab is pressed (see commit 62569dd).
#
# Each test runs in a fresh `zsh --no-rcs -c` subshell so the plugin is being
# sourced for the first time in that process.

test_first_source_captures_existing_tab_binding() {
  local out
  out=$(zshz_in_fresh_shell 'print -- $ZSHZ[TAB_BINDING]')
  assert_eq "expand-or-complete" "$out" "TAB_BINDING should hold the prior binding"
}

test_first_source_binds_tab_to_widget() {
  local out
  out=$(zshz_in_fresh_shell "bindkey -M main '^I'")
  assert_contains "_zshz_zle_completion_widget" "$out" "Tab should be bound to the widget after sourcing"
}

test_resource_does_not_capture_own_widget() {
  local out
  out=$(zshz_in_fresh_shell "
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    print -- \$ZSHZ[TAB_BINDING]
  ")
  assert_ne "_zshz_zle_completion_widget" "$out" "re-source must not capture its own widget"
  assert_eq "expand-or-complete" "$out" "TAB_BINDING should still be the original binding"
}

test_resource_keeps_tab_bound_to_widget() {
  local out
  out=$(zshz_in_fresh_shell "
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    bindkey -M main '^I'
  ")
  assert_contains "_zshz_zle_completion_widget" "$out" "Tab should still be bound to the widget after re-source"
}

test_first_source_preserves_non_default_tab_binding() {
  local out
  out=$(zsh --no-rcs -c "
    autoload -U menu-complete; zle -N menu-complete
    bindkey -M main '^I' menu-complete
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    print -- \$ZSHZ[TAB_BINDING]
  ")
  assert_eq "menu-complete" "$out" "user's non-default Tab binding should be captured verbatim"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
