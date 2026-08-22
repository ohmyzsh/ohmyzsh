if (( ! $+commands[stripe] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `stripe`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_stripe" ]]; then
  typeset -g -A _comps
  autoload -Uz _stripe
  _comps[stripe]=_stripe
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_stripe"
  zf_mv -f -- =( stripe completion --shell zsh --write-to-stdout ) "$TMPPREFIX"
} &|
