# Autocompletion for the JetBrains Qodana CLI (qodana).
if (( ! $+commands[qodana] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `qodana`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_qodana" ]]; then
  typeset -g -A _comps
  autoload -Uz _qodana
  _comps[qodana]=_qodana
fi

qodana completion zsh >| "$ZSH_CACHE_DIR/completions/_qodana" &|
