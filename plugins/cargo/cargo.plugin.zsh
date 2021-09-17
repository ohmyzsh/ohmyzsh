# COMPLETION FUNCTION
if (( $+commands[rustup] && $+commands[cargo] )); then
  if [[ ! -f $ZSH_CACHE_DIR/cargo_version ]] \
    || [[ "$(cargo --version)" != "$(< "$ZSH_CACHE_DIR/cargo_version")" ]] \
    || [[ ! -f $ZSH/plugins/cargo/_cargo ]]; then
    rustup completions zsh cargo > $ZSH/plugins/cargo/_cargo
    cargo --version > $ZSH_CACHE_DIR/cargo_version
  fi
  autoload -Uz _cargo
  _comps[cargo]=_cargo
fi
