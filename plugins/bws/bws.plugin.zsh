# Autocompletion for the Bitwarden Secrets CLI (bws).
if (( ! $+commands[bws] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `bws`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_bws" ]]; then
  typeset -g -A _comps
  autoload -Uz _bws
  _comps[bws]=_bws
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/._bws"
  zf_mv -f -- =( bws completions zsh ) "$ZSH_CACHE_DIR/completions/_bws"
} &|
