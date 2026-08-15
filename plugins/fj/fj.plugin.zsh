# Autocompletion for the Forgejo CLI (fj).
if (( ! $+commands[fj] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `fj`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_fj" ]]; then
  typeset -g -A _comps
  autoload -Uz _fj
  _comps[fj]=_fj
fi

fj completion zsh >| "$ZSH_CACHE_DIR/completions/_fj" &|