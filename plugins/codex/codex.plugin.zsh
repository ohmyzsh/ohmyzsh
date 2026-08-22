# COMPLETION FUNCTION
if (( ! $+commands[codex] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `codex`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_codex" ]]; then
  typeset -g -A _comps
  autoload -Uz _codex
  _comps[codex]=_codex
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_codex"
  zf_mv -f -- =( codex completion zsh < /dev/null 2> /dev/null ) "$TMPPREFIX"
} &|
