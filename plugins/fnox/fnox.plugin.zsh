if (( ! $+commands[fnox] )); then
  # if we don't have fnox at all just bail out
  return
fi

if (( ! $+commands[mise] )); then
  # if we have fnox but not mise, source its activation directly
  eval "$(fnox activate zsh)"
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `mise`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_fnox" ]]; then
  typeset -g -A _comps
  autoload -Uz _fnox
  _comps[fnox]=_fnox
fi

# Generate and load completions
fnox completion zsh >| "$ZSH_CACHE_DIR/completions/_fnox" &|
