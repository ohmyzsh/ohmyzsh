virtualenvwrapper='virtualenvwrapper.sh'

if (( $+commands[$virtualenvwrapper] )); then
  source ${${virtualenvwrapper}:c}
elif [[ -f "/etc/bash_completion.d/virtualenvwrapper" ]]; then
  virtualenvwrapper="/etc/bash_completion.d/virtualenvwrapper"
  source "/etc/bash_completion.d/virtualenvwrapper"
else
  print "zsh virtualenvwrapper plugin: Cannot find ${virtualenvwrapper}.\n"\
        "Please install with \`pip install virtualenvwrapper\`" >&2
  return
fi
if ! type workon &>/dev/null; then
  print "zsh virtualenvwrapper plugin: shell function 'workon' not defined.\n"\
        "Please check ${virtualenvwrapper}" >&2
  return
fi

if [[ "$WORKON_HOME" == "" ]]; then
  print "\$WORKON_HOME is not defined so ZSH plugin virtualenvwrapper will not work" >&2
  return
fi

if [[ ! $DISABLE_VENV_CD -eq 1 ]]; then
  # Automatically activate Git projects's virtual environments based on the
  # directory name of the project. Virtual environment name can be overridden
  # by placing a .venv file in the project root with a virtualenv name in it
  function workon_cwd {
    if [ ! $WORKON_CWD ]; then
      WORKON_CWD=1
      # Check if this is a Git repo
      PROJECT_ROOT=`git rev-parse --show-toplevel 2> /dev/null`
      if (( $? != 0 )); then
        PROJECT_ROOT="."
      fi
      # Check for virtualenv name override
      if [[ -f "$PROJECT_ROOT/.venv" ]]; then
        ENV_NAME=`cat "$PROJECT_ROOT/.venv"`
      elif [[ -f "$PROJECT_ROOT/.venv/bin/activate" ]];then
        ENV_NAME="$PROJECT_ROOT/.venv"
      elif [[ "$PROJECT_ROOT" != "." ]]; then
        ENV_NAME=`basename "$PROJECT_ROOT"`
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
      unset PROJECT_ROOT
      unset WORKON_CWD
    fi
  }

  # Append workon_cwd to the chpwd_functions array, so it will be called on cd
  # http://zsh.sourceforge.net/Doc/Release/Functions.html
  if ! (( $chpwd_functions[(I)workon_cwd] )); then
    chpwd_functions+=(workon_cwd)
  fi
fi
