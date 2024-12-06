# Autocompletion for the rustup CLI (rustup).
if (( !$+commands[rustup] )); then
  return
fi
# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `rustup`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_rustup" ]]; then
  typeset -g -A _comps
  autoload -Uz _rustup
  _comps[rustup]=_rustup
fi

# Generate and load rustup completion
rustup completions zsh >! "$ZSH_CACHE_DIR/completions/_rustup" &|