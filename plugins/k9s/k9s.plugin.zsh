if (( ! $+commands[k9s] )); then
  return
fi

# If the completion file does not exist, fake it and load it
if [[ ! -f "$ZSH_CACHE_DIR/completions/_k9s" ]]; then
  typeset -g -A _comps
  autoload -Uz _k9s
  _comps[k9s]=_k9s
fi

# and then generate it in the background. On first completion,
# the actual completion file will be loaded.
k9s completion zsh >| "$ZSH_CACHE_DIR/completions/_k9s" &|
