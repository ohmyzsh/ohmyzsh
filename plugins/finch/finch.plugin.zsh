if (( ! $+commands[finch] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `finch`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_finch" ]]; then
  typeset -g -A _comps
  autoload -Uz _finch
  _comps[finch]=_finch
fi

finch completion zsh 2> /dev/null >| "$ZSH_CACHE_DIR/completions/_finch" &|

alias fvm='finch vm'
