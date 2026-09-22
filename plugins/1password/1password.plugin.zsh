# Do nothing if op is not installed
(( ${+commands[op]} )) || return

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `op`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_op" ]]; then
  typeset -g -A _comps
  autoload -Uz _op
  _comps[op]=_op
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_op"
  zf_mv -f -- =( op completion zsh ) "$TMPPREFIX"
} &|

# Load opswd function
autoload -Uz opswd
