if (( ! $+commands[helm] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `helm`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_helm" ]]; then
  typeset -g -A _comps
  autoload -Uz _helm
  _comps[helm]=_helm
fi

helm completion zsh >| "$ZSH_CACHE_DIR/completions/_helm" &|
