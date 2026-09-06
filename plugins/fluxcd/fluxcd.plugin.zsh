# Autocompletion for the FluxCD CLI (flux).
if (( ! $+commands[flux] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `flux`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_flux" ]]; then
  typeset -g -A _comps
  autoload -Uz _flux
  _comps[flux]=_flux
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_flux"
  zf_mv -f -- =( flux completion zsh ) "$TMPPREFIX"
} &|
