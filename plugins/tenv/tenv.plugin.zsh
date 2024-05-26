# Autocompletion for tenv
if (( ! $+commands[tenv] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `tenv`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_tenv" ]]; then
  typeset -g -A _comps
  autoload -Uz _tenv
  _comps[tenv]=_tenv
fi

tenv completion zsh >| "$ZSH_CACHE_DIR/completions/_tenv" &|

