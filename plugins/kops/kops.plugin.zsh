# Autocompletion for the Kubernetes Operations CLI (kops).
if (( ! $+commands[kops] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `kops`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_kops" ]]; then
  typeset -g -A _comps
  autoload -Uz _kops
  _comps[kops]=_kops
fi

kops completion zsh >| "$ZSH_CACHE_DIR/completions/_kops" &|
