if (( ! $+commands[pitchfork] )); then
  return
fi

# Load pitchfork hooks
eval "$(pitchfork activate zsh)"

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `pitchfork`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_pitchfork" ]]; then
  typeset -g -A _comps
  autoload -Uz _pitchfork
  _comps[pitchfork]=_pitchfork
fi

# Generate and load pitchfork completion
pitchfork completion zsh >| "$ZSH_CACHE_DIR/completions/_pitchfork" &|
