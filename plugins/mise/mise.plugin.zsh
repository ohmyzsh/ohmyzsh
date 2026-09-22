if (( $+commands[mise] )); then
  _mise_bin=mise
elif [[ -x ~/.local/bin/mise ]]; then
  _mise_bin=~/.local/bin/mise
else
  return
fi

# Load mise hooks
eval "$($_mise_bin activate zsh)"
unset _mise_bin

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `mise`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_mise" ]]; then
  typeset -g -A _comps
  autoload -Uz _mise
  _comps[mise]=_mise
fi

# Generate and load mise completion
zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/_mise"
  zf_mv -f -- =( mise completion zsh ) "$TMPPREFIX"
} &|
