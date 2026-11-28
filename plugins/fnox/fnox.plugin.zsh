if (( ! $+commands[fnox] )); then
  # if we don't have fnox at all just bail out
  return
fi

eval "$(fnox activate zsh)"

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `fnox`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_fnox" ]]; then
  typeset -g -A _comps
  autoload -Uz _fnox
  _comps[fnox]=_fnox
fi

# Regenerate completions when the executable changes.
if [[ ! -s "$ZSH_CACHE_DIR/completions/_fnox" || "$commands[fnox]" -nt "$ZSH_CACHE_DIR/completions/_fnox" ]]; then
  zmodload -F zsh/files b:zf_mv
  () {
    local TMPPREFIX="$ZSH_CACHE_DIR/completions/._fnox"
    zf_mv -f -- =( fnox completion zsh ) "$ZSH_CACHE_DIR/completions/_fnox"
  } &|
fi
