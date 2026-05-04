# Autocompletion for sprite
if (( ! $+commands[sprite] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `sprite`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_sprite" ]]; then
  typeset -g -A _comps
  autoload -Uz _sprite
  _comps[sprite]=_sprite
fi

sprite completion zsh >| "$ZSH_CACHE_DIR/completions/_sprite" &|
