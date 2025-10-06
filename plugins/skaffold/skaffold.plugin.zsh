# Autocompletion for skaffold
if (( ! $+commands[skaffold] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `skaffold`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_skaffold" ]]; then
  typeset -g -A _comps
  autoload -Uz _skaffold
  _comps[skaffold]=_skaffold
fi

skaffold completion zsh >| "$ZSH_CACHE_DIR/completions/_skaffold" &|
