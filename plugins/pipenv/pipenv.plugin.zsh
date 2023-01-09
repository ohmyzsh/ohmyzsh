if (( ! $+commands[pipenv] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `pipenv`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_pipenv" ]]; then
  typeset -g -A _comps
  autoload -Uz _pipenv
  _comps[pipenv]=_pipenv
fi

_PIPENV_COMPLETE=zsh_source pipenv >| "$ZSH_CACHE_DIR/completions/_pipenv" &|

# Automatic pipenv shell activation/deactivation
_togglePipenvShell() {
  # deactivate shell if Pipfile doesn't exist and not in a subdir
  if [[ ! -f "$PWD/Pipfile" ]]; then
    if [[ "$PIPENV_ACTIVE" == 1 ]]; then
      if [[ "$PWD" != "$pipfile_dir"* ]]; then
        exit
      fi
    fi
  fi

  # activate the shell if Pipfile exists
  if [[ "$PIPENV_ACTIVE" != 1 ]]; then
    if [[ -f "$PWD/Pipfile" ]]; then
      export pipfile_dir="$PWD"
      pipenv shell
    fi
  fi
}
autoload -U add-zsh-hook
add-zsh-hook chpwd _togglePipenvShell
_togglePipenvShell

# Aliases
alias pch="pipenv check"
alias pcl="pipenv clean"
alias pgr="pipenv graph"
alias pi="pipenv install"
alias pidev="pipenv install --dev"
alias pl="pipenv lock"
alias po="pipenv open"
alias prun="pipenv run"
alias psh="pipenv shell"
alias psy="pipenv sync"
alias pu="pipenv uninstall"
alias pwh="pipenv --where"
alias pvenv="pipenv --venv"
alias ppy="pipenv --py"
