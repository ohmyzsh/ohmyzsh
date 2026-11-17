# Autocompletion for the Bitwarden CLI (bw).
if (( ! $+commands[bw] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `bw`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_bw" ]]; then
  typeset -g -A _comps
  autoload -Uz _bw
  _comps[bw]=_bw
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/._bw"
  zf_mv -f -- =( bw completion --shell zsh ) "$ZSH_CACHE_DIR/completions/_bw"
} &|
