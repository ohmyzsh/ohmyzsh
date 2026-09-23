# Completion
if (( ! $+commands[sops] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `sops`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_sops" ]]; then
  typeset -g -A _comps
  autoload -Uz _sops
  _comps[sops]=_sops
fi

sops completion zsh >| "$ZSH_CACHE_DIR/completions/_sops" &|
