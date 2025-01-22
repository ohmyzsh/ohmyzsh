if (( ! $+commands[tailscale] && ! $+aliases[tailscale] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `tailscale`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_tailscale" ]]; then
  typeset -g -A _comps
  autoload -Uz _tailscale

  if (( $+commands[tailscale] )); then
    _comps[tailscale]=_tailscale
  elif (( $+aliases[tailscale] )); then
    _comps[${aliases[tailscale]:t}]=_tailscale
  fi
fi

tailscale completion zsh >| "$ZSH_CACHE_DIR/completions/_tailscale" &|
