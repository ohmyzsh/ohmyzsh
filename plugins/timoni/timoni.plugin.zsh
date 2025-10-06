# Autocompletion for the Timoni CLI (timoni).
if (( ! $+commands[timoni] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `timoni`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_timoni" ]]; then
  typeset -g -A _comps
  autoload -Uz _timoni
  _comps[timoni]=_timoni
fi

timoni completion zsh >| "$ZSH_CACHE_DIR/completions/_timoni" &|
