<<<<<<< HEAD
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
  print "zsh virtualenvwrapper plugin: Cannot find ${virtualenvwrapper}.\n"\
        "Please install with \`pip install virtualenvwrapper\`" >&2
  return
fi
if ! type workon &>/dev/null; then
  print "zsh virtualenvwrapper plugin: shell function 'workon' not defined.\n"\
=======
function {
    # search in these locations for the init script:
    for virtualenvwrapper in $commands[virtualenvwrapper_lazy.sh] \
      $commands[virtualenvwrapper.sh] \
      /usr/share/virtualenvwrapper/virtualenvwrapper{_lazy,}.sh \
      /usr/local/bin/virtualenvwrapper{_lazy,}.sh \
      /etc/bash_completion.d/virtualenvwrapper \
      /usr/share/bash-completion/completions/virtualenvwrapper \
      $HOME/.local/bin/virtualenvwrapper.sh
    do
        if [[ -f "$virtualenvwrapper" ]]; then
            source "$virtualenvwrapper"
            return
        fi
    done
    print "[oh-my-zsh] virtualenvwrapper plugin: Cannot find virtualenvwrapper.sh.\n"\
          "Please install with \`pip install virtualenvwrapper\`" >&2
    return 1
}

if [[ $? -eq 0 ]] && ! type workon &>/dev/null; then
  print "[oh-my-zsh] virtualenvwrapper plugin: shell function 'workon' not defined.\n"\
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
        "Please check ${virtualenvwrapper}" >&2
  return
fi

<<<<<<< HEAD
if [[ "$WORKON_HOME" == "" ]]; then
  print "\$WORKON_HOME is not defined so ZSH plugin virtualenvwrapper will not work" >&2
  return
fi

if [[ ! $DISABLE_VENV_CD -eq 1 ]]; then
  # Automatically activate Git projects' virtual environments based on the
  # directory name of the project. Virtual environment name can be overridden
  # by placing a .venv file in the project root with a virtualenv name in it
  function workon_cwd {
    if [ ! $WORKON_CWD ]; then
      WORKON_CWD=1
      # Check if this is a Git repo
      # Get absolute path, resolving symlinks
      PROJECT_ROOT="${PWD:A}"
      while [[ "$PROJECT_ROOT" != "/" && ! -e "$PROJECT_ROOT/.venv" ]]; do
        PROJECT_ROOT="${PROJECT_ROOT:h}"
      done
      if [[ "$PROJECT_ROOT" == "/" ]]; then
        PROJECT_ROOT="."
      fi
      # Check for virtualenv name override
      if [[ -f "$PROJECT_ROOT/.venv" ]]; then
        ENV_NAME=`cat "$PROJECT_ROOT/.venv"`
      elif [[ -f "$PROJECT_ROOT/.venv/bin/activate" ]];then
        ENV_NAME="$PROJECT_ROOT/.venv"
      elif [[ "$PROJECT_ROOT" != "." ]]; then
=======
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
      # Get absolute path, resolving symlinks
      local PROJECT_ROOT="${PWD:A}"
      while [[ "$PROJECT_ROOT" != "/" && ! -e "$PROJECT_ROOT/.venv" \
          && ! -d "$PROJECT_ROOT/.git" ]]; do
        PROJECT_ROOT="${PROJECT_ROOT:h}"
      done

      # Check for virtualenv name override
      if [[ -f "$PROJECT_ROOT/.venv" ]]; then
        ENV_NAME="$(cat "$PROJECT_ROOT/.venv")"
      elif [[ -f "$PROJECT_ROOT/.venv/bin/activate" ]];then
        ENV_NAME="$PROJECT_ROOT/.venv"
      elif [[ "$PROJECT_ROOT" != "/" ]]; then
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
        ENV_NAME="${PROJECT_ROOT:t}"
      else
        ENV_NAME=""
      fi
<<<<<<< HEAD
      if [[ "$ENV_NAME" != "" ]]; then
        # Activate the environment only if it is not already active
        if [[ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]]; then
=======
      
      if [[ -n $CD_VIRTUAL_ENV && "$ENV_NAME" != "$CD_VIRTUAL_ENV" ]]; then
        # We've just left the repo, deactivate the environment
        # Note: this only happens if the virtualenv was activated automatically
        if [[ -n "$VIRTUAL_ENV" ]]; then
          # Only deactivate if VIRTUAL_ENV was set
          # User may have deactivated manually or via another mechanism
          deactivate
        fi
        # clean up regardless
        unset CD_VIRTUAL_ENV
      fi
      if [[ "$ENV_NAME" != "" ]]; then
        # Activate the environment only if it is not already active
        if [[ ! "$VIRTUAL_ENV" -ef "$WORKON_HOME/$ENV_NAME" ]]; then
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
          if [[ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]]; then
            workon "$ENV_NAME" && export CD_VIRTUAL_ENV="$ENV_NAME"
          elif [[ -e "$ENV_NAME/bin/activate" ]]; then
            source $ENV_NAME/bin/activate && export CD_VIRTUAL_ENV="$ENV_NAME"
<<<<<<< HEAD
          fi
        fi
      elif [[ -n $CD_VIRTUAL_ENV && -n $VIRTUAL_ENV ]]; then
=======
          else
            ENV_NAME=""
          fi
        fi
      fi
      if [[ "$ENV_NAME" == "" && -n $CD_VIRTUAL_ENV && -n $VIRTUAL_ENV ]]; then
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
        # We've just left the repo, deactivate the environment
        # Note: this only happens if the virtualenv was activated automatically
        deactivate && unset CD_VIRTUAL_ENV
      fi
<<<<<<< HEAD
      unset PROJECT_ROOT
      unset WORKON_CWD
=======
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
    fi
  }

  # Append workon_cwd to the chpwd_functions array, so it will be called on cd
  # http://zsh.sourceforge.net/Doc/Release/Functions.html
<<<<<<< HEAD
  if ! (( $chpwd_functions[(I)workon_cwd] )); then
    chpwd_functions+=(workon_cwd)
  fi
=======
  autoload -U add-zsh-hook
  add-zsh-hook chpwd workon_cwd
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
fi
