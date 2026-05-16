if (( ! $+commands[minikube] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `minikube`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_minikube" ]]; then
  typeset -g -A _comps
  autoload -Uz _minikube
  _comps[minikube]=_minikube
fi

minikube completion zsh >| "$ZSH_CACHE_DIR/completions/_minikube" &|
