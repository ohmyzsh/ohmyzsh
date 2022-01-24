if (( ! $+commands[rbw] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `rbw`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_rbw" ]]; then
  typeset -g -A _comps
  autoload -Uz _rbw
  _comps[rbw]=_rbw
fi

rbw gen-completions zsh >| "$ZSH_CACHE_DIR/completions/_rbw" &|
