# Autocompletion for the Concourse CLI (fly).
if (( ! $+commands[fly] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `fly`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_fly" ]]; then
  typeset -g -A _comps
  autoload -Uz _fly
  _comps[fly]=_fly
fi

fly completion --shell zsh >| "$ZSH_CACHE_DIR/completions/_fly" &|
