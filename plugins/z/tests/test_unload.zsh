# Plugin unload / reload contract.
#
# Per the Zsh Plugin Standard
# (https://github.com/agkozak/Zsh-100-Commits-Club/blob/master/Zsh-Plugin-Standard.adoc#unload-fun),
# `zsh-z_plugin_unload` should fully remove the plugin: drop its functions and
# widget, restore the prior Tab binding, remove its precmd/chpwd hooks, and
# unset the ZSHZ global. Re-sourcing afterward should bring everything back.
#
# Each test runs in a fresh `zsh --no-rcs -c` subshell.

test_unload_removes_zshz_function() {
  local out
  out=$(zshz_in_fresh_shell '
    zsh-z_plugin_unload
    print -- ${+functions[zshz]}
  ')
  assert_eq "0" "$out" "zshz function should be gone after unload"
}

test_unload_unsets_ZSHZ_global() {
  local out
  out=$(zshz_in_fresh_shell '
    zsh-z_plugin_unload
    print -- ${+ZSHZ}
  ')
  assert_eq "0" "$out" "ZSHZ should be unset after unload"
}

test_unload_removes_widget() {
  local out
  out=$(zshz_in_fresh_shell '
    zsh-z_plugin_unload
    print -- ${+widgets[_zshz_zle_completion_widget]}
  ')
  assert_eq "0" "$out" "widget should be deleted after unload"
}

test_unload_restores_prior_tab_binding() {
  local out
  out=$(zshz_in_fresh_shell "
    zsh-z_plugin_unload
    bindkey -M main '^I'
  ")
  assert_contains "expand-or-complete" "$out" "Tab should return to its prior binding"
  assert_not_contains "_zshz_zle_completion_widget" "$out" "widget should not still be on Tab"
}

test_unload_leaves_user_rebound_tab_alone() {
  # If the user rebinds Tab themselves after sourcing, unload must NOT silently
  # undo that rebind. Regression for commit e55ae41 ("unload: only restore Tab
  # binding when appropriate").
  local out
  out=$(zshz_in_fresh_shell "
    bindkey -M main '^I' menu-complete
    zsh-z_plugin_unload
    bindkey -M main '^I'
  ")
  assert_contains "menu-complete" "$out" "user's later rebind should survive unload"
}

test_unload_removes_hooks() {
  local out
  out=$(zshz_in_fresh_shell '
    zsh-z_plugin_unload
    print precmd=${precmd_functions[(r)_zshz_precmd]:-none}
    print chpwd=${chpwd_functions[(r)_zshz_chpwd]:-none}
  ')
  assert_contains "precmd=none" "$out" "_zshz_precmd hook should be gone"
  assert_contains "chpwd=none" "$out" "_zshz_chpwd hook should be gone"
}

test_unload_leaves_no_plugin_functions_behind() {
  # zshz defines its helper functions (including zshz_cd and _zshz_echo) the
  # first time it runs, so run it once before unloading; then sweep the
  # function table for anything plugin-shaped that unload failed to remove.
  local out
  out=$(zshz_in_fresh_shell '
    zshz -l > /dev/null 2>&1
    zsh-z_plugin_unload
    print -r -- ${(M)${(k)functions}:#(zshz*|_zshz*|zsh-z*)}
  ')
  assert_eq "" "$out" "no plugin functions should remain after unload"
}

test_unload_removes_plugin_dir_from_fpath() {
  local out
  out=$(zshz_in_fresh_shell "
    zsh-z_plugin_unload
    if (( \${fpath[(ie)$PLUGIN_DIR]} <= \${#fpath} )); then
      print in
    else
      print out
    fi
  ")
  assert_eq "out" "$out" "plugin directory should be gone from fpath after unload"
}

test_unload_keeps_fpath_entry_matching_pwd() {
  # Inside a function, \$0 is the function name, which `:A' resolves relative
  # to \$PWD -- so an unload that recomputes \${0:A:h} strips the current
  # directory from fpath instead of the plugin directory. An entry that merely
  # equals \$PWD must survive unload.
  local out
  out=$(zshz_in_fresh_shell "
    fpath+=( '$TESTDIR' )
    zsh-z_plugin_unload
    if (( \${fpath[(ie)$TESTDIR]} <= \${#fpath} )); then
      print kept
    else
      print dropped
    fi
  ")
  assert_eq "kept" "$out" "an fpath entry equal to PWD must survive unload"
}

test_unload_then_reload_restores_function_and_widget() {
  local out
  local -a lines
  out=$(zshz_in_fresh_shell "
    zsh-z_plugin_unload
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    print -- \${+functions[zshz]}
    print -- \${+widgets[_zshz_zle_completion_widget]}
    bindkey -M main '^I'
  ")
  lines=( ${(f)out} )
  assert_eq "1" "$lines[1]" "zshz function should exist after reload"
  assert_eq "1" "$lines[2]" "widget should exist after reload"
  assert_contains "_zshz_zle_completion_widget" "$lines[3]" "Tab should be bound to widget after reload"
}

test_reload_after_unload_captures_current_tab_binding() {
  # After unload restored the prior binding, re-sourcing should treat the
  # *current* Tab binding as "the binding to chain to" -- not stale state from
  # before the unload.
  local out
  out=$(zshz_in_fresh_shell "
    zsh-z_plugin_unload
    bindkey -M main '^I' menu-complete
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    print -- \$ZSHZ[TAB_BINDING]
  ")
  assert_eq "menu-complete" "$out" "reload should capture the binding present at reload time"
}

# The completion mapping the widget installs on its first Tab is plugin state
# like any other, and it outlives the function it names: `_zshz' is
# unfunctioned by unload and the plugin directory leaves $fpath, so an entry
# still pointing at it is unloadable. These need compinit and a real widget
# call, so they use raw `zsh -c' rather than `zshz_in_fresh_shell'.

test_unload_removes_the_completion_mapping_it_registered() {
  local out
  out=$(zsh --no-rcs -c "
    bindkey -M main '^I' expand-or-complete
    fpath=( '$PLUGIN_DIR' \$fpath )
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    autoload -U compinit
    compinit -u -d \$(mktemp -u) 2> /dev/null
    zle() { return 0 }
    LBUFFER='z foo'
    _zshz_zle_completion_widget
    [[ \${_comps[z]:-} == _zshz ]] || { print 'precondition failed: not registered'; exit 1 }
    zsh-z_plugin_unload
    print -- \${_comps[z]:-NONE}
  ")
  assert_eq "NONE" "$out" \
    "unload must remove the _comps entry the widget registered"
}

test_unload_leaves_the_static_compdef_registration_alone() {
  # `_comps[zshz]' comes from compinit reading the `#compdef' tag, not from
  # Zsh-z at runtime. Nothing re-runs compinit when the plugin is sourced
  # again, so removing this one would break completion for the literal `zshz'
  # command until the user re-ran compinit by hand.
  local out
  out=$(zsh --no-rcs -c "
    bindkey -M main '^I' expand-or-complete
    fpath=( '$PLUGIN_DIR' \$fpath )
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    autoload -U compinit
    compinit -u -d \$(mktemp -u) 2> /dev/null
    zle() { return 0 }
    LBUFFER='z foo'
    _zshz_zle_completion_widget
    zsh-z_plugin_unload
    print -- \${_comps[zshz]:-NONE}
  ")
  assert_eq "_zshz" "$out" \
    "unload must leave compinit's own registration in place"
}

test_unload_leaves_a_reassigned_completion_mapping_alone() {
  # Zsh-z never overwrites an existing mapping, so it must not delete one that
  # someone else repointed after it registered.
  local out
  out=$(zsh --no-rcs -c "
    bindkey -M main '^I' expand-or-complete
    fpath=( '$PLUGIN_DIR' \$fpath )
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    autoload -U compinit
    compinit -u -d \$(mktemp -u) 2> /dev/null
    zle() { return 0 }
    LBUFFER='z foo'
    _zshz_zle_completion_widget
    _other_completer() { : }
    compdef _other_completer z
    zsh-z_plugin_unload
    print -- \${_comps[z]:-NONE}
  ")
  assert_eq "_other_completer" "$out" \
    "unload must not delete a completion mapping it does not own"
}

test_reload_reregisters_the_completion_mapping_after_unload() {
  # What makes removing the entry safe: the widget puts it back on the next
  # Tab, so an unload/reload cycle ends up where it started.
  local out
  out=$(zsh --no-rcs -c "
    bindkey -M main '^I' expand-or-complete
    fpath=( '$PLUGIN_DIR' \$fpath )
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    autoload -U compinit
    compinit -u -d \$(mktemp -u) 2> /dev/null
    zle() { return 0 }
    LBUFFER='z foo'
    _zshz_zle_completion_widget
    zsh-z_plugin_unload
    fpath=( '$PLUGIN_DIR' \$fpath )
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    LBUFFER='z foo'
    _zshz_zle_completion_widget
    print -- \${_comps[z]:-NONE}
  ")
  assert_eq "_zshz" "$out" \
    "a reload's first Tab must re-register the mapping unload removed"
}

# $fpath ownership. The plugin adds its own directory only when nothing else
# has, so unload must take back only what it put there -- a plugin manager
# that supplied the entry owns it, and other autoloadable functions may live
# in the same directory. `zshz_in_fresh_shell' sources the plugin for us, so
# these use raw `zsh -c' to arrange $fpath beforehand.

# Count occurrences of $PLUGIN_DIR in $fpath inside a fresh shell running BODY.
_count_plugin_dir_in_fpath() {
  zsh --no-rcs -c "
    $1
    _m=( \${(M)fpath:#$PLUGIN_DIR} )
    print -- \${#_m}
  "
}

test_unload_leaves_a_preexisting_fpath_entry_alone() {
  local out
  out=$(_count_plugin_dir_in_fpath "
    fpath=( '$PLUGIN_DIR' \$fpath )
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    zsh-z_plugin_unload
  ")
  assert_eq "1" "$out" \
    "unload must not remove an fpath entry the plugin did not add"
}

test_unload_leaves_duplicate_preexisting_fpath_entries_alone() {
  # The old filter dropped every match at once, so duplicates a manager had
  # put there disappeared together.
  local out
  out=$(_count_plugin_dir_in_fpath "
    fpath=( '$PLUGIN_DIR' '$PLUGIN_DIR' \$fpath )
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    zsh-z_plugin_unload
  ")
  assert_eq "2" "$out" \
    "unload must leave duplicate entries it did not add"
}

test_unload_removes_the_fpath_entry_it_added() {
  local out
  out=$(_count_plugin_dir_in_fpath "
    fpath=( \${fpath:#$PLUGIN_DIR} )
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    zsh-z_plugin_unload
  ")
  assert_eq "0" "$out" \
    "unload must remove the fpath entry the plugin added"
}

test_unload_removes_the_fpath_entry_after_a_re_source() {
  # A re-source finds the directory already on $fpath -- because the first
  # source put it there -- so the ownership record must survive rather than be
  # recomputed, or unload would strand the entry.
  local out
  out=$(_count_plugin_dir_in_fpath "
    fpath=( \${fpath:#$PLUGIN_DIR} )
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    zsh-z_plugin_unload
  ")
  assert_eq "0" "$out" \
    "the ownership record must survive a re-source"
}

test_unload_removes_the_fpath_entry_from_a_glob_metachar_directory() {
  # The stored path is looked up with `(ie)'/`(Ie)' -- exact match. Without the
  # `e' the subscript reads it as a *pattern*, so a plugin directory named with
  # `[', `*' or `?' would fail to match itself and its entry would outlive the
  # unload.
  local d="$TESTDIR/plug[in]"
  mkdir -p "$d"
  cp "$PLUGIN_DIR/zsh-z.plugin.zsh" "$PLUGIN_DIR/_zshz" "$d/" || return 1

  local out
  out=$(zsh --no-rcs -c "
    d='$d'
    source \$d/zsh-z.plugin.zsh
    zsh-z_plugin_unload
    print -- \${fpath[(Ie)\$d]}
  ")
  assert_eq "0" "$out" \
    "unload must remove its fpath entry from a directory whose name contains glob metacharacters"
}

test_unload_removes_every_completion_mapping_it_registered() {
  # A re-source with a changed $ZSHZ_CMD registers a second command while the
  # first mapping is still live. A single-slot ownership record would forget
  # the earlier one and leave it pointing at the removed `_zshz'.
  local out
  out=$(zsh --no-rcs -c "
    bindkey -M main '^I' expand-or-complete
    fpath=( '$PLUGIN_DIR' \$fpath )
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    autoload -U compinit
    compinit -u -d \$(mktemp -u) 2> /dev/null
    zle() { return 0 }
    LBUFFER='z foo'
    _zshz_zle_completion_widget
    ZSHZ_CMD=zoo
    source '$PLUGIN_DIR/zsh-z.plugin.zsh'
    LBUFFER='zoo foo'
    _zshz_zle_completion_widget
    [[ \${_comps[z]:-} == _zshz && \${_comps[zoo]:-} == _zshz ]] ||
      { print 'precondition failed: both mappings should be registered'; exit 1 }
    zsh-z_plugin_unload
    print -- \"\${_comps[z]:-NONE} \${_comps[zoo]:-NONE}\"
  ")
  assert_eq "NONE NONE" "$out" \
    "unload must remove every mapping it registered, not only the most recent"
}

test_unload_removes_the_directory_it_added_not_the_one_resourced_from() {
  # $ZSHZ[PLUGIN_DIR] is rewritten by every source, so an ownership *flag*
  # would describe whichever installation was sourced last. Re-sourcing from a
  # second, manager-owned directory then made unload drop that manager's entry
  # while stranding the one the plugin had actually added -- exactly backwards.
  local a="$TESTDIR/instA" b="$TESTDIR/instB"
  mkdir -p "$a" "$b"
  cp "$PLUGIN_DIR/zsh-z.plugin.zsh" "$PLUGIN_DIR/_zshz" "$a/" || return 1
  cp "$PLUGIN_DIR/zsh-z.plugin.zsh" "$PLUGIN_DIR/_zshz" "$b/" || return 1

  local out
  out=$(zsh --no-rcs -c "
    a='$a'; b='$b'
    fpath=( \$b \$fpath )          # the manager owns B
    source \$a/zsh-z.plugin.zsh    # the plugin adds A itself
    source \$b/zsh-z.plugin.zsh    # re-sourced from B, which was already there
    zsh-z_plugin_unload
    print -- \"\${fpath[(Ie)\$a]} \$(( \${fpath[(Ie)\$b]} > 0 ))\"
  ")
  assert_eq "0 1" "$out" \
    "unload must remove the entry it added (A) and keep the manager's (B)"
}
# vim: fdm=indent:ts=2:et:sts=2:sw=2:
