if (( ! $+commands[pipenv] )); then
  return
fi

# Compatibility note:
# pipenv < 2026.5.0 used Click-based shell completion driven by the
# _PIPENV_COMPLETE environment variable.
#
# pipenv >= 2026.5.0 removed this mechanism and switched to argcomplete-based
# completion using register-python-argcomplete instead.

if (( $+commands[register-python-argcomplete] )); then
  # pipenv >= 2026.5.0 (argcomplete-based completion)
  autoload -U bashcompinit
  bashcompinit

  eval "$(register-python-argcomplete pipenv)"

else
  # pipenv < 2026.5.0 (legacy Click-based completion via _PIPENV_COMPLETE)

  # If the completion file doesn't exist yet, we need to autoload it and
  # bind it to `pipenv`. Otherwise, compinit will have already done that.
  if [[ ! -f "$ZSH_CACHE_DIR/completions/_pipenv" ]]; then
    typeset -g -A _comps
    autoload -Uz _pipenv
    _comps[pipenv]=_pipenv
  fi

  _PIPENV_COMPLETE=zsh_source pipenv >| "$ZSH_CACHE_DIR/completions/_pipenv" &|
fi

if zstyle -T ':omz:plugins:pipenv' auto-shell; then
  # Automatic pipenv shell activation/deactivation
  _togglePipenvShell() {
    # deactivate shell if Pipfile doesn't exist and not in a subdir
    if [[ ! -f "$PWD/Pipfile" ]]; then
      if [[ "$PIPENV_ACTIVE" == 1 ]]; then
        if [[ "$PWD" != "$pipfile_dir"* ]]; then
          unset PIPENV_ACTIVE pipfile_dir
          deactivate
        fi
      fi
    fi

    # activate the shell if Pipfile exists
    if [[ "$PIPENV_ACTIVE" != 1 ]]; then
      if [[ -f "$PWD/Pipfile" ]]; then
        export pipfile_dir="$PWD"
        source "$(pipenv --venv)/bin/activate"
        export PIPENV_ACTIVE=1
      fi
    fi
  }

  autoload -U add-zsh-hook
  add-zsh-hook chpwd _togglePipenvShell
  _togglePipenvShell
fi

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
alias pupd="pipenv update"
alias pwh="pipenv --where"
alias pvenv="pipenv --venv"
alias ppy="pipenv --py"
