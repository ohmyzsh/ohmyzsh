# Autocompletion for argocd.
if (( ! $+commands[argocd] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `argocd`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_argocd" ]]; then
  typeset -g -A _comps
  autoload -Uz _argocd
  _comps[argocd]=_argocd
fi

{
  local completion="$ZSH_CACHE_DIR/completions/_argocd" tmp
  tmp=$(command mktemp -t _omz_comp.XXXXXXXX) || exit
  argocd completion zsh >| "$tmp" && command mv -f "$tmp" "$completion"
  command rm -f "$tmp"
} &|
