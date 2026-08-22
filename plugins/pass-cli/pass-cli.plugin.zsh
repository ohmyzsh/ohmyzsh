# Autocompletion for Proton Pass CLI (pass-cli)
if (( ! $+commands[pass-cli] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `pass-cli`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_pass-cli" ]]; then
  typeset -g -A _comps
  autoload -Uz _pass-cli
  _comps[pass-cli]=_pass-cli
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_pass-cli"
  zf_mv -f -- =( pass-cli completions zsh ) "$TMPPREFIX"
} &|
