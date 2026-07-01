# Completion
if (( ! $+commands[stern] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `stern`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_stern" ]]; then
  typeset -g -A _comps
  autoload -Uz _stern
  _comps[stern]=_stern
fi

stern --completion zsh >| "$ZSH_CACHE_DIR/completions/_stern" &|
