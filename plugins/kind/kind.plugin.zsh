if (( ! $+commands[kind] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `kind`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_kind" ]]; then
  typeset -g -A _comps
  autoload -Uz _kind
  _comps[kind]=_kind
fi

# Generate and load kind completion
kind completion zsh >! "$ZSH_CACHE_DIR/completions/_kind" &|
