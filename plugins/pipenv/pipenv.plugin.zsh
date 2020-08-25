# Pipenv completion
_pipenv() {
  eval $(env COMMANDLINE="${words[1,$CURRENT]}" _PIPENV_COMPLETE=complete-zsh pipenv)
}
compdef _pipenv pipenv

POST_EXIT_DIR="${ZSH_CACHE_DIR:-$ZSH/cache}/pipenv-post-exit-dir"

# Automatic pipenv shell activation/deactivation
_togglePipenvShell() {
  # deactivate shell if active and and not in a subdir of original pipenv
  if [[ "$PIPENV_ACTIVE" == 1 ]]; then
    if [[ "$PWD" != "$pipfile_dir"* ]]; then
      echo "$PWD" > "$POST_EXIT_DIR"
      unset pipfile_dir
      exit
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

_changeDirPostExit() {
  if [[ "$PIPENV_ACTIVE" != 1 ]]; then
    if [[ -f "$POST_EXIT_DIR" ]]; then
      new_dir=$(cat "$POST_EXIT_DIR")
      rm "$POST_EXIT_DIR"
      cd "$new_dir"
    fi
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _togglePipenvShell
add-zsh-hook chpwd _changeDirPostExit
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
