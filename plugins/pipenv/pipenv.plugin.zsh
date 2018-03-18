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

