#compdef pipenv
_pipenv() {
  eval $(env COMMANDLINE="${words[1,$CURRENT]}" _PIPENV_COMPLETE=complete-zsh  pipenv)
}

_togglePipenvShell() {
  # deactivate shell if Pipfile doesn't exit and not in a sub dir
  if [[ ! -a "$PWD/Pipfile" ]]; then
      if [[ "$PIPENV_ACTIVE" == 1 ]]; then
          if [[ "$PWD" != "$pipfile_dir"* ]]; then
            exit
          fi
    fi
  fi

  # activate the shell if Pipfile exists
  if [[ "$PIPENV_ACTIVE" != 1 ]]; then
    if [[ -a "$PWD/Pipfile" ]]; then
      export pipfile_dir="$PWD"
      pipenv shell
    fi
  fi
}

if [[ "$(basename ${(%):-%x})" != "_pipenv" ]]; then
  autoload -U compinit && compinit
  compdef _pipenv pipenv
fi

export PROMPT_COMMAND=_togglePipenvShell
if [ -n "$ZSH_VERSION" ]; then
  function chpwd() {
    _togglePipenvShell
  }
fi

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
