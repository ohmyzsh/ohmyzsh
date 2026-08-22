# Autocompletion for the Buf CLI (buf).
if (( !$+commands[buf] )); then
  return
fi
# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `buf`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_buf" ]]; then
  typeset -g -A _comps
  autoload -Uz _buf
  _comps[buf]=_buf
fi

# Generate and load buf completion
zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_buf"
  zf_mv -f -- =( buf completion zsh ) "$TMPPREFIX"
} &|
