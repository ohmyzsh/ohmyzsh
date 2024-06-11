# Return immediately if poetry is not found
if (( ! $+commands[poetry] )); then
  return
fi

alias pa='poetry add'
alias pb='poetry build'
alias pc='poetry check'
alias pi='poetry install'
alias pl='poetry lock'
alias pr='poetry run'
alias pu='poetry update'
alias pli='poetry list'
alias pad='poetry add -G dev' 
alias pconf='poetry config --list'
alias pexp='poetry export --without-hashes > requirements.txt'
alias pin='poetry init'
alias pnew='poetry new'
alias pplug='poetry self show plugins'
alias ppub='poetry publish'
alias prm='poetry remove'
alias psh='poetry shell'
alias pshw='poetry show'
alias pslt='poetry show --latest'
alias psad='poetry self add'
alias psup='poetry self update'
alias psync='poetry install --sync'
alias ptree='poetry show --tree'
alias pvinf='poetry env info'
alias pvoff='poetry config virtualenvs.create false'
alias pvrm='poetry env remove'
alias pvu='poetry env use'
alias ppath='poetry env info --path'

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `poetry`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_poetry" ]]; then
  typeset -g -A _comps
  autoload -Uz _poetry
  _comps[poetry]=_poetry
fi

poetry completions zsh >| "$ZSH_CACHE_DIR/completions/_poetry" &|
