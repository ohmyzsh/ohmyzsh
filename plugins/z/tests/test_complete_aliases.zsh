# Tab completion under `setopt COMPLETE_ALIASES'.
#
# compinit parses the static `#compdef' tag in `_zshz' literally -- the
# `${ZSHZ_CMD:-...}' part of `#compdef zshz ${ZSHZ_CMD:-${_Z_CMD:-z}}' is
# never expanded, so only the literal `zshz' command gets registered at
# compinit time. Without COMPLETE_ALIASES that's enough: zsh expands the
# alias `z' -> `zshz 2>&1' before the completion lookup, so `_comps[zshz]'
# is consulted. Under COMPLETE_ALIASES the lookup is verbatim and would
# miss `_zshz' entirely.
#
# The widget compensates by populating `_comps[$cmd]' on first invocation,
# guarded by `(( ${+_comps[$cmd]} ))' so a user-defined completer for the
# same name is left alone. We can't drive a real ZLE session
# non-interactively, so each test stubs `zle' and calls the widget directly.

test_alias_is_defined_after_sourcing() {
  local out
  out=$(zsh --no-rcs -c "
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    print -- \${aliases[z]:-NONE}
  ")
  assert_eq "zshz 2>&1" "$out" "alias z should be 'zshz 2>&1' after sourcing"
}

test_static_compdef_registers_zshz_literal() {
  # Sanity check: compinit picks up the literal `zshz' from the #compdef tag.
  # This is what makes tab completion work without COMPLETE_ALIASES (zsh
  # expands the alias first, then looks up `_comps[zshz]').
  local out
  out=$(zsh --no-rcs -c "
    bindkey -M main '^I' expand-or-complete
    fpath=( '$PLUGIN_DIR' \$fpath )
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    autoload -U compinit
    compinit -u -d \$(mktemp -u) 2> /dev/null
    print -- \${_comps[zshz]:-NONE}
  ")
  assert_eq "_zshz" "$out" "_comps[zshz] should be set by the static #compdef tag"
}

test_widget_registers_alias_on_first_invocation() {
  local out
  out=$(zsh --no-rcs -c "
    bindkey -M main '^I' expand-or-complete
    fpath=( '$PLUGIN_DIR' \$fpath )
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    autoload -U compinit
    compinit -u -d \$(mktemp -u) 2> /dev/null
    [[ -z \${_comps[z]:-} ]] || { print 'precondition failed: _comps[z] already set'; exit 1 }
    zle() { return 0 }
    LBUFFER='z foo'
    _zshz_zle_completion_widget
    print -- \${_comps[z]:-NONE}
  ")
  assert_eq "_zshz" "$out" "first widget call should register _comps[z]"
}

test_widget_registers_alias_under_complete_aliases() {
  # The headline COMPLETE_ALIASES scenario: with the option set, zsh looks up
  # the completion by the alias name verbatim, so `_comps[z]' has to be _zshz.
  local out
  out=$(zsh --no-rcs -c "
    bindkey -M main '^I' expand-or-complete
    setopt COMPLETE_ALIASES
    fpath=( '$PLUGIN_DIR' \$fpath )
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    autoload -U compinit
    compinit -u -d \$(mktemp -u) 2> /dev/null
    zle() { return 0 }
    LBUFFER='z foo'
    _zshz_zle_completion_widget
    print -- \${_comps[z]:-NONE}
  ")
  assert_eq "_zshz" "$out" "_comps[z] must be _zshz after one widget call under COMPLETE_ALIASES"
}

test_widget_registers_alias_for_custom_ZSHZ_CMD() {
  local out
  out=$(zsh --no-rcs -c "
    bindkey -M main '^I' expand-or-complete
    ZSHZ_CMD=zoo
    fpath=( '$PLUGIN_DIR' \$fpath )
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    autoload -U compinit
    compinit -u -d \$(mktemp -u) 2> /dev/null
    zle() { return 0 }
    LBUFFER='zoo foo'
    _zshz_zle_completion_widget
    print -- \${_comps[zoo]:-NONE}
  ")
  assert_eq "_zshz" "$out" "_comps[zoo] should be set when ZSHZ_CMD=zoo"
}

test_widget_does_not_overwrite_existing_comps_entry() {
  # If the user has already mapped the alias name to another completer, the
  # guard `(( ${+_comps[$cmd]} )) ||' must defer rather than clobber.
  local out
  out=$(zsh --no-rcs -c "
    bindkey -M main '^I' expand-or-complete
    fpath=( '$PLUGIN_DIR' \$fpath )
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    autoload -U compinit
    compinit -u -d \$(mktemp -u) 2> /dev/null
    _comps[z]=_some_other_completer
    zle() { return 0 }
    LBUFFER='z foo'
    _zshz_zle_completion_widget
    print -- \${_comps[z]:-NONE}
  ")
  assert_eq "_some_other_completer" "$out" "pre-existing _comps[\$cmd] must not be overwritten"
}

# vim: fdm=indent:ts=2:et:sts=2:sw=2:
