# Return immediately if ruff is not found
if (( ! ${+commands[ruff]} )); then
  return
fi

alias ruc='ruff check'
alias rucf='ruff check --fix'
alias ruf='ruff format'
alias rufc='ruff format --check'
alias rur='ruff rule'
alias rul='ruff linter'
alias rucl='ruff clean'
alias ruup='ruff self update'

# If the completion file doesn't exist yet, we need to autoload it and
# bind it. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_ruff" ]]; then
  typeset -g -A _comps
  autoload -Uz _ruff
  _comps[ruff]=_ruff
fi

# Overwrites the file each time as completions might change with ruff versions.
ruff generate-shell-completion zsh >| "$ZSH_CACHE_DIR/completions/_ruff" &|
