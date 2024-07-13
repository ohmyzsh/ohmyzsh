alias pad='poetry add'
alias pbld='poetry build'
alias pch='poetry check'
alias pcmd='poetry list'
alias pconf='poetry config --list'
alias pexp='poetry export --without-hashes > requirements.txt'
alias pin='poetry init'
alias pinst='poetry install'
alias plck='poetry lock'
alias pnew='poetry new'
alias ppath='poetry env info --path'
alias pplug='poetry self show plugins'
alias ppub='poetry publish'
alias prm='poetry remove'
alias prun='poetry run'
alias psad='poetry self add'
alias psh='poetry shell'
alias pshw='poetry show'
alias pslt='poetry show --latest'
alias psup='poetry self update'
alias psync='poetry install --sync'
alias ptree='poetry show --tree'
alias pup='poetry update'
alias pvinf='poetry env info'
alias pvoff='poetry config virtualenvs.create false'
alias pvrm='poetry env remove'
alias pvu='poetry env use'

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
