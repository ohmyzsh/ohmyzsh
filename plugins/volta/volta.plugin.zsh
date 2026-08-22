# COMPLETION FUNCTION
if (( ! $+commands[volta] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `volta`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_volta" ]]; then
  typeset -g -A _comps
  autoload -Uz _volta
  _comps[volta]=_volta
fi

{
  local completion="$ZSH_CACHE_DIR/completions/_volta" tmp
  tmp=$(command mktemp "$completion.XXXXXX") || exit
  volta completions zsh >| "$tmp" && command mv -f "$tmp" "$completion"
  command rm -f "$tmp"
} &|
