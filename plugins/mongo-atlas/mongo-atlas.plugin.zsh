# Autocompletion for the Mongo Atlas CLI (atlas).
if (( ! $+commands[atlas] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `atlas`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_atlas" ]]; then
  typeset -g -A _comps
  autoload -Uz _atlas
  _comps[atlas]=_atlas
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_atlas"
  zf_mv -f -- =( atlas completion zsh ) "$TMPPREFIX"
} &|
