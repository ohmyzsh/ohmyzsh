# Autocompletion for the Charm CLI (charm).
if (( ! $+commands[charm] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `charm`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_charm" ]]; then
  typeset -g -A _comps
  autoload -Uz _charm
  _comps[charm]=_charm
fi

{
  local completion="$ZSH_CACHE_DIR/completions/_charm" tmp
  tmp=$(command mktemp -t _omz_comp.XXXXXXXX) || exit
  charm completion zsh >| "$tmp" && command mv -f "$tmp" "$completion"
  command rm -f "$tmp"
} &|
