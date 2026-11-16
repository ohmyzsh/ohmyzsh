# Autocompletion for the Istio CLI (istioctl).
if (( ! $+commands[istioctl] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `istioctl`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_istioctl" ]]; then
  typeset -g -A _comps
  autoload -Uz _istioctl
  _comps[istioctl]=_istioctl
fi

istioctl completion zsh >| "$ZSH_CACHE_DIR/completions/_istioctl" &|
