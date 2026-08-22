# If Bun is not found, don't do the rest of the script
if (( ! $+commands[bun] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `bun`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_bun" ]]; then
  typeset -g -A _comps
  autoload -Uz _bun
  _comps[bun]=_bun
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_bun"
  zf_mv -f -- =( SHELL=zsh bun completions ) "$TMPPREFIX"
} &|
