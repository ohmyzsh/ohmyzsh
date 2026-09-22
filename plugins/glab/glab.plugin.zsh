# Autocompletion for the GitLab CLI (glab).
if (( ! $+commands[glab] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `glab`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_glab" ]]; then
  typeset -g -A _comps
  autoload -Uz _glab
  _comps[glab]=_glab
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_glab"
  zf_mv -f -- =( glab completion -s zsh ) "$TMPPREFIX"
} &|
