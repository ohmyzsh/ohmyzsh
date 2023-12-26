# rtx needs to be in $PATH
if (( ! ${+commands[rtx]} )); then
  return
fi

# Load rtx hooks
eval "$(rtx activate zsh)"

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `rtx`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_rtx" ]]; then
  typeset -g -A _comps
  autoload -Uz _rtx
  _comps[rtx]=_rtx
fi

# Generate and load rtx completion
rtx completion zsh >! "$ZSH_CACHE_DIR/completions/_rtx" &|
