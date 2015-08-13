virtualenvwrapper='virtualenvwrapper.sh'

if (( $+commands[$virtualenvwrapper] )); then
  function {
    setopt local_options
    unsetopt equals
    source ${${virtualenvwrapper}:c}
  }
elif [[ -f "/etc/bash_completion.d/virtualenvwrapper" ]]; then
  function {
    setopt local_options
    unsetopt equals
    virtualenvwrapper="/etc/bash_completion.d/virtualenvwrapper"
    source "/etc/bash_completion.d/virtualenvwrapper"
  }
else
  print "[oh-my-zsh] virtualenvwrapper plugin: Cannot find ${virtualenvwrapper}.\n"\
        "Please install with \`pip install virtualenvwrapper\`" >&2
  return
fi
if ! type workon &>/dev/null; then
  print "[oh-my-zsh] virtualenvwrapper plugin: shell function 'workon' not defined.\n"\
        "Please check ${virtualenvwrapper}" >&2
  return
fi

if [[ "$WORKON_HOME" == "" ]]; then
  print "[oh-my-zsh] \$WORKON_HOME is not defined so plugin virtualenvwrapper will not work" >&2
  return
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
      if [[ "$ENV_NAME" != "" ]]; then
        # Activate the environment only if it is not already active
        if [[ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]]; then
          if [[ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]]; then
            workon "$ENV_NAME" && export CD_VIRTUAL_ENV="$ENV_NAME"
          elif [[ -e "$ENV_NAME/bin/activate" ]]; then
            source $ENV_NAME/bin/activate && export CD_VIRTUAL_ENV="$ENV_NAME"
          fi
        fi
      elif [[ -n $CD_VIRTUAL_ENV && -n $VIRTUAL_ENV ]]; then
        # We've just left the repo, deactivate the environment
        # Note: this only happens if the virtualenv was activated automatically
        deactivate && unset CD_VIRTUAL_ENV
      fi
    fi
  }

  # Append workon_cwd to the chpwd_functions array, so it will be called on cd
  # http://zsh.sourceforge.net/Doc/Release/Functions.html
  if ! (( $chpwd_functions[(I)workon_cwd] )); then
    chpwd_functions+=(workon_cwd)
  fi
fi
