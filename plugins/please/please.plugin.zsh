# Autocompletion for the Please build system CLI (plz).
if (( ! $+commands[plz] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `plz`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_plz" ]]; then
  typeset -g -A _comps
  autoload -Uz _plz
  _comps[plz]=_plz
fi

plz --completion_script >| "$ZSH_CACHE_DIR/completions/_plz" &|

alias pb='plz build'
alias pt='plz test'
alias pw='plz watch'
