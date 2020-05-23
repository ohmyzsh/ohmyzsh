# Pipenv completion
_pipenv() {
  eval $(env COMMANDLINE="${words[1,$CURRENT]}" _PIPENV_COMPLETE=complete-zsh  pipenv)
}
compdef _pipenv pipenv

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
