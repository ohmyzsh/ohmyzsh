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

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_argocd"
  zf_mv -f -- =( argocd completion zsh ) "$TMPPREFIX"
} &|
