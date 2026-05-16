if (( ! $+commands[mise] )); then
  return
fi

# Load mise hooks
eval "$(mise activate zsh)"

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `mise`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_mise" ]]; then
  typeset -g -A _comps
  autoload -Uz _mise
  _comps[mise]=_mise
fi

# Generate and load mise completion
mise completion zsh >| "$ZSH_CACHE_DIR/completions/_mise" &|
