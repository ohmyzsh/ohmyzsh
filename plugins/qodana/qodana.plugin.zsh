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

{
  local completion="$ZSH_CACHE_DIR/completions/_qodana" tmp
  tmp=$(command mktemp "$completion.XXXXXX") || exit
  qodana completion zsh >| "$tmp" && command mv -f "$tmp" "$completion"
  command rm -f "$tmp"
} &|
