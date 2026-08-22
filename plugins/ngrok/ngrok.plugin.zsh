# Autocompletion for ngrok
if (( ! $+commands[ngrok] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `ngrok`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_ngrok" ]]; then
  typeset -g -A _comps
  autoload -Uz _ngrok
  _comps[ngrok]=_ngrok
fi

{
  local completion="$ZSH_CACHE_DIR/completions/_ngrok" tmp
  tmp=$(command mktemp "$completion.XXXXXX") || exit
  ngrok completion zsh >| "$tmp" && command mv -f "$tmp" "$completion"
  command rm -f "$tmp"
} &|
