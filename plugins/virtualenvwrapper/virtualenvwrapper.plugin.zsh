function {
    # search in these locations for the init script:
    for f in $commands[virtualenvwrapper_lazy.sh] \
             $commands[virtualenvwrapper.sh] \
             /usr/share/virtualenvwrapper/virtualenvwrapper{_lazy,}.sh \
             /usr/local/bin/virtualenvwrapper{_lazy,}.sh \
             /etc/bash_completion.d/virtualenvwrapper \
             /usr/share/bash-completion/completions/virtualenvwrapper
    do
        if [[ -f $f ]]; then
            source $f
            return
        fi
    done
    print "[oh-my-zsh] virtualenvwrapper plugin: Cannot find virtualenvwrapper.sh.\n"\
          "Please install with \`pip install virtualenvwrapper\`" >&2
}

if ! type workon &>/dev/null; then
  print "[oh-my-zsh] virtualenvwrapper plugin: shell function 'workon' not defined.\n"\
        "Please check ${virtualenvwrapper}" >&2
  return
fi

if [[ -z "$WORKON_HOME" ]]; then
  WORKON_HOME="$HOME/.virtualenvs"
fi

if [[ ! $DISABLE_VENV_CD -eq 1 ]]; then
  # Automatically activate Git projects or other customized virtualenvwrapper projects based on the
  # directory name of the project. Virtual environment name can be overridden
  # by placing a .venv file in the project root with a virtualenv name in it.
  function workon_cwd {
    if [[ -z "$WORKON_CWD" ]]; then
      local WORKON_CWD=1
      # Check if this is a Git repo
      local GIT_REPO_ROOT=""
      local GIT_TOPLEVEL="$(git rev-parse --show-toplevel 2> /dev/null)"
      if [[ $? == 0 ]]; then
        GIT_REPO_ROOT="$GIT_TOPLEVEL"
      fi
      # Get absolute path, resolving symlinks
      local PROJECT_ROOT="${PWD:A}"
      while [[ "$PROJECT_ROOT" != "/" && ! -e "$PROJECT_ROOT/.venv" \
               && ! -d "$PROJECT_ROOT/.git"  && "$PROJECT_ROOT" != "$GIT_REPO_ROOT" ]]; do
        PROJECT_ROOT="${PROJECT_ROOT:h}"
      done
      if [[ "$PROJECT_ROOT" == "/" ]]; then
        PROJECT_ROOT="."
      fi
      # Check for virtualenv name override
      if [[ -f "$PROJECT_ROOT/.venv" ]]; then
        ENV_NAME="$(cat "$PROJECT_ROOT/.venv")"
      elif [[ -f "$PROJECT_ROOT/.venv/bin/activate" ]];then
        ENV_NAME="$PROJECT_ROOT/.venv"
      elif [[ "$PROJECT_ROOT" != "." ]]; then
        ENV_NAME="${PROJECT_ROOT:t}"
      else
        ENV_NAME=""
      fi
      
      if [[ -n $CD_VIRTUAL_ENV && "$ENV_NAME" != "$CD_VIRTUAL_ENV" ]]; then
        # We've just left the repo, deactivate the environment
        # Note: this only happens if the virtualenv was activated automatically
        deactivate && unset CD_VIRTUAL_ENV
      fi
      if [[ "$ENV_NAME" != "" ]]; then
        # Activate the environment only if it is not already active
        if [[ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]]; then
          if [[ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]]; then
            workon "$ENV_NAME" && export CD_VIRTUAL_ENV="$ENV_NAME"
          elif [[ -e "$ENV_NAME/bin/activate" ]]; then
            source $ENV_NAME/bin/activate && export CD_VIRTUAL_ENV="$ENV_NAME"
          fi
        fi
      fi
    fi
  }

  # Append workon_cwd to the chpwd_functions array, so it will be called on cd
  # http://zsh.sourceforge.net/Doc/Release/Functions.html
  autoload -U add-zsh-hook
  add-zsh-hook chpwd workon_cwd
fi
