if (( $+commands[mise] )); then
  _mise_bin=$commands[mise]
elif [[ -x ~/.local/bin/mise ]]; then
  _mise_bin=~/.local/bin/mise
else
  return
fi

# Load mise hooks
eval "$($_mise_bin activate zsh)"

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `mise`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_mise" ]]; then
  typeset -g -A _comps
  autoload -Uz _mise
  _comps[mise]=_mise
fi

# Generate completion only when missing/empty or stale relative to the mise binary.
if [[ ! -s "$ZSH_CACHE_DIR/completions/_mise" || "$_mise_bin" -nt "$ZSH_CACHE_DIR/completions/_mise" ]]; then
  zmodload -F zsh/files b:zf_mv
  () {
    local TMPPREFIX="$ZSH_CACHE_DIR/completions/._mise"
    zf_mv -f -- =( "$_mise_bin" completion zsh ) "$ZSH_CACHE_DIR/completions/_mise"
  } &|
fi

unset _mise_bin
