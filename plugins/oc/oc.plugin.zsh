# Autocompletion for oc, the command line interface for OpenShift
#
# Author: https://github.com/kevinkirkup

if (( ! $+commands[oc] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `oc`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_oc" ]]; then
  typeset -g -A _comps
  autoload -Uz _oc
  _comps[oc]=_oc
fi

oc completion zsh >| "$ZSH_CACHE_DIR/completions/_oc" &|
