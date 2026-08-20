# Completion
if (( ! $+commands[helmfile] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `helmfile`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_helmfile" ]]; then
  typeset -g -A _comps
  autoload -Uz _helmfile
  _comps[helmfile]=_helmfile
fi

helmfile completion zsh >| "$ZSH_CACHE_DIR/completions/_helmfile" &|

# Aliases
alias hf='helmfile'
alias hfi='helmfile --interactive'
