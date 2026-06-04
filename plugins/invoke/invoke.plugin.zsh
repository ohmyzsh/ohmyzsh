# Autocompletion for the Invoke CLI (invoke).
if (( ! $+commands[invoke] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `invoke`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_invoke" ]]; then
  typeset -g -A _comps
  autoload -Uz _invoke
  _comps[invoke]=_invoke
fi

invoke --print-completion-script=zsh >| "$ZSH_CACHE_DIR/completions/_invoke" &|
