# Autocompletion for the Grafana CLI (gcx).
if (( ! $+commands[gcx] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `gcx`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_gcx" ]]; then
  typeset -g -A _comps
  autoload -Uz _gcx
  _comps[gcx]=_gcx
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_gcx"
  zf_mv -f -- =( gcx completion zsh ) "$TMPPREFIX"
} &|
