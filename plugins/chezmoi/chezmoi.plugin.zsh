# COMPLETION FUNCTION
if (( ! $+commands[chezmoi] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `chezmoi`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_chezmoi" ]]; then
  typeset -g -A _comps
  autoload -Uz _chezmoi
  _comps[chezmoi]=_chezmoi
fi

{
  local completion="$ZSH_CACHE_DIR/completions/_chezmoi" tmp
  tmp=$(command mktemp "$completion.XXXXXX") || exit
  chezmoi completion zsh >| "$tmp" && command mv -f "$tmp" "$completion"
  command rm -f "$tmp"
} &|
