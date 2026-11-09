# Autocompletion for the Operator SDK CLI (operator-sdk).
if (( ! $+commands[operator-sdk] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `operator-sdk`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_operator-sdk" ]]; then
  typeset -g -A _comps
  autoload -Uz _operator-sdk
  _comps[operator-sdk]=_operator-sdk
fi

operator-sdk completion zsh >| "$ZSH_CACHE_DIR/completions/_operator-sdk" &|
