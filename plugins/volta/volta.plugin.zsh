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

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_volta"
  zf_mv -f -- =( volta completions zsh ) "$TMPPREFIX"
} &|
