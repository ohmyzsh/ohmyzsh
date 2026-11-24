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
alias pshw='poetry show'
alias pslt='poetry show --latest'
alias psup='poetry self update'
alias ptree='poetry show --tree'
alias pup='poetry update'
alias pvinf='poetry env info'
alias pvoff='poetry config virtualenvs.create false'
alias pvrm='poetry env remove'
alias pvu='poetry env use'

# Poetry 2.0 moved `poetry shell` to the poetry-plugin-shell plugin, so fall
# back to activating the virtualenv in the current shell when it's missing.
function psh {
  if poetry shell --help &>/dev/null; then
    poetry shell "$@"
  else
    eval "$(poetry env activate)"
  fi
}

# Poetry 2.0 replaced `poetry install --sync` with `poetry sync`.
function psync {
  if poetry sync --help &>/dev/null; then
    poetry sync "$@"
  else
    poetry install --sync "$@"
  fi
}

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

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/._poetry"
  zf_mv -f -- =( poetry completions zsh ) "$ZSH_CACHE_DIR/completions/_poetry"
} &|
