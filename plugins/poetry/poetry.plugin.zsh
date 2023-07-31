alias pad='poetry add'
alias pbld='poetry build'
alias pch='poetry check'
alias pnew='poetry new'
alias pcmd='poetry list'
alias pconf='poetry config --list'
alias pexp='poetry export --without-hashes > requirements.txt'
alias pin='poetry init'
alias pinst='poetry install'
alias plock='poetry lock'
alias pplug='poetry self show plugins'
alias ppub='poetry publish'
alias prm='poetry remove'
alias prun='poetry run'
alias psad='poetry self add'
alias psh='poetry shell'
alias pshow='poetry show'
alias psup='poetry self update'
alias psync='poetry install --sync'
alias pup='poetry update'

# Return immediately if poetry is not found
if (( ! $+commands[poetry] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `poetry`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_poetry" ]]; then
  typeset -g -A _comps
  autoload -Uz _poetry
  _comps[poetry]=_poetry
fi

poetry completions zsh >| "$ZSH_CACHE_DIR/completions/_poetry" &|
