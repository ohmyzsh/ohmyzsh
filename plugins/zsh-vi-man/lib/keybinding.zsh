# lib/keybinding.zsh - Keybinding management for different shell modes
# Supports vi normal/insert modes and emacs mode

# Internal function to bind keys in all configured modes
_zvm_man_bind_key() {
  # Bind in vi normal mode (always enabled)
  bindkey -M vicmd "${ZVM_MAN_KEY}" zvm-man 2>/dev/null

  # Handle emacs mode binding
  if [[ "${ZVM_MAN_ENABLE_EMACS}" == true ]]; then
    bindkey -M emacs "${ZVM_MAN_KEY_EMACS}" zvm-man 2>/dev/null
  else
    # Remove existing binding if disabled
    bindkey -M emacs -r "${ZVM_MAN_KEY_EMACS}" 2>/dev/null
  fi

  # Handle vi insert mode binding
  if [[ "${ZVM_MAN_ENABLE_INSERT}" == true ]]; then
    bindkey -M viins "${ZVM_MAN_KEY_INSERT}" zvm-man 2>/dev/null
  else
    # Remove existing binding if disabled
    bindkey -M viins -r "${ZVM_MAN_KEY_INSERT}" 2>/dev/null
  fi
}

# Public function for users to manually rebind if needed
# Usage: zvm_man_rebind
zvm_man_rebind() {
  _zvm_man_bind_key
}

# Setup keybindings with zsh-vi-mode compatibility
# Handles both immediate binding and lazy loading scenarios
zvm_setup_keybindings() {
  if (( ${+functions[zvm_after_lazy_keybindings]} )); then
    # zsh-vi-mode is loaded with lazy keybindings, hook into it
    if [[ -z "${ZVM_LAZY_KEYBINDINGS}" ]] || [[ "${ZVM_LAZY_KEYBINDINGS}" == true ]]; then
      zvm_after_lazy_keybindings_commands+=(_zvm_man_bind_key)
    else
      _zvm_man_bind_key
    fi
  elif (( ${+functions[zvm_after_init]} )); then
    # zsh-vi-mode without lazy keybindings
    zvm_after_init_commands+=(_zvm_man_bind_key)
  else
    # Standalone or other vi-mode setups - bind immediately
    _zvm_man_bind_key
  fi
}

