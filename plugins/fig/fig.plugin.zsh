if ! (( $+commands[fig] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `fig`. Otherwise, compinit will have already done that
if [[ ! -f "$ZSH_CACHE_DIR/completions/_fig" ]]; then
  autoload -Uz _fig
  typeset -g -A _comps
  _comps[fig]=_fig
fi

fig completion zsh >| "$ZSH_CACHE_DIR/completions/_fig" &|
