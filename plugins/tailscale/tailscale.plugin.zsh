if (( ! $+commands[tailscale] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `tailscale`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_tailscale" ]]; then
  typeset -g -A _comps
  autoload -Uz _tailscale
  _comps[tailscale]=_tailscale
fi

tailscale completion zsh >| "$ZSH_CACHE_DIR/completions/_tailscale" &|
