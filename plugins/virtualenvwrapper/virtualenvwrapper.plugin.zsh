WRAPPER_FOUND=0
for wrapsource in "/usr/local/bin/virtualenvwrapper.sh" "/etc/bash_completion.d/virtualenvwrapper" ; do
  if [[ -e $wrapsource ]] ; then
    WRAPPER_FOUND=1
    source $wrapsource

    if [[ ! $DISABLE_VENV_CD -eq 1 ]]; then
      # Automatically activate Git projects' virtual environments based on the
      # directory name of the project. Virtual environment name can be overridden
      # by placing a .venv file in the project root with a virtualenv name in it
      function workon_cwd {
          # Check that this is a Git repo
          GIT_DIR=`git rev-parse --git-dir 2> /dev/null`
          if (( $? == 0 )); then
              # Find the repo root and check for virtualenv name override
              GIT_DIR=`readlink -f $GIT_DIR`
              PROJECT_ROOT=`dirname "$GIT_DIR"`
              ENV_NAME=`basename "$PROJECT_ROOT"`
              if [[ -f "$PROJECT_ROOT/.venv" ]]; then
                  ENV_NAME=`cat "$PROJECT_ROOT/.venv"`
              fi
              # Activate the environment only if it is not already active
              if [[ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]]; then
                  if [[ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]]; then
                      workon "$ENV_NAME" && export CD_VIRTUAL_ENV="$ENV_NAME"
                  fi
              fi
          elif [ $CD_VIRTUAL_ENV ]; then
              # We've just left the repo, deactivate the environment
              # Note: this only happens if the virtualenv was activated automatically
              deactivate && unset CD_VIRTUAL_ENV
          fi
      }

      # New cd function that does the virtualenv magic
      function cd {
          builtin cd "$@" && workon_cwd
      }
    fi

    break
  fi
done

if [ $WRAPPER_FOUND -eq 0 ] ; then
  print "zsh virtualenvwrapper plugin: Couldn't activate virtualenvwrapper. Please run \`pip install virtualenvwrapper\`."
fi
