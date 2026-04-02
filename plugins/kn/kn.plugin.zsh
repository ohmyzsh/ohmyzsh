# Autocompletion for kn, the command line interface for Knative.
#
# Author: https://github.com/btannous

if (( ! $+commands[kn] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `kn`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_kn" ]]; then
  typeset -g -A _comps
  autoload -Uz _kn
  _comps[kn]=_kn
fi

kn completion zsh >| "$ZSH_CACHE_DIR/completions/_kn" &|
