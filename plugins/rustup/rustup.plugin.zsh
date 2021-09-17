# COMPLETION FUNCTION
if (( $+commands[rustup] )); then
  if [[ ! -f $ZSH_CACHE_DIR/rustup_version ]] \
    || [[ "$(rustup --version 2> /dev/null)" \
      != "$(< "$ZSH_CACHE_DIR/rustup_version")" ]] \
    || [[ ! -f $ZSH/plugins/rustup/_rustup ]]; then
    rustup completions zsh > $ZSH/plugins/rustup/_rustup
    rustup --version 2> /dev/null > $ZSH_CACHE_DIR/rustup_version
  fi
  autoload -Uz _rustup
  _comps[rustup]=_rustup
fi
