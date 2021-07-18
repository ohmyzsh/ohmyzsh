# Automatically generate the completion file for rustup.

if (( $+commands[rustup] )); then
  if [[ ! -r "$ZSH_CACHE_DIR/rustup_version" \
    || "$(rustup --version)" != "$(< "$ZSH_CACHE_DIR/rustup_version")"
    || ! -f "$ZSH/plugins/rustup/_rustup" ]]; then
    rustup completions zsh > $ZSH/plugins/rustup/_rustup
    rustup --version > $ZSH_CACHE_DIR/rustup_version
  fi
  autoload -Uz _rustup
  _comps[rustup]=_rustup
fi
