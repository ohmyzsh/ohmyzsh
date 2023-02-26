if [[ $? -eq 0 ]] && ! type toolbox &>/dev/null; then
  print "[oh-my-zsh] toolbox plugin: shell function 'toolbox' not defined.\n" \
    "Please check toolbox" >&2
  return
fi

function is_in_toolbox() {
  [[ -f /run/.containerenv && -f /run/.toolboxenv ]]
}

function toolbox_prompt_info() {
  if is_in_toolbox; then
    echo "⬢ "
  fi
}

function toolbox_name {
  # Get absolute path, resolving symlinks
  local PROJECT_ROOT="${PWD:A}"
  while [[ "$PROJECT_ROOT" != "/" && ! -e "$PROJECT_ROOT/.toolbox" &&
    ! -d "$PROJECT_ROOT/.git" ]]; do
    PROJECT_ROOT="${PROJECT_ROOT:h}"
  done

  # Check for toolbox name override
  if [[ -f "$PROJECT_ROOT/.toolbox" ]]; then
    echo "$(<"$PROJECT_ROOT/.toolbox")"
  elif [[ -d "$PROJECT_ROOT/.git" && -n "$TOOLBOX_DEFAULT_CONTAINER" ]]; then
    echo "$TOOLBOX_DEFAULT_CONTAINER"
  fi
}


# Automatically enter Git projects in the default toolbox container. Toolbox
# container can be overridden by placing a .toolbox file in the project root
# with a container name in it.
#
function toolbox_cwd {
  if [[ -z "$TOOLBOX_CWD" ]]; then
    local TOOLBOX_CWD=1
    local TOOLBOX_NAME=$(toolbox_name)

    if [[ -n "$TOOLBOX_NAME" ]]; then
      if ! is_in_toolbox; then
        if ! $(podman container exists "$TOOLBOX_NAME"); then
          tbc "$TOOLBOX_NAME"
        fi
        toolbox --container "$TOOLBOX_NAME" run sudo hostname "$TOOLBOX_NAME"
        toolbox enter "$TOOLBOX_NAME"
      fi
    elif [[ "$(hostname)" != "toolbox" && $DISABLE_TOOLBOX_EXIT -ne 1 ]]; then
      if is_in_toolbox; then
        exit
      fi
    fi
  fi
}

if [[ $DISABLE_TOOLBOX_ENTER -ne 1 ]]; then
  # Append toolbox_cwd to the chpwd_functions array, so it will be called on cd
  # http://zsh.sourceforge.net/Doc/Release/Functions.html
  autoload -Uz add-zsh-hook
  add-zsh-hook chpwd toolbox_cwd
fi


alias tb="toolbox"
alias tbi="echo $TOOLBOX_DEFAULT_CONTAINER > .toolbox && toolbox_cwd"
alias tbrm="toolbox rm"
alias tbrmi="toolbox rmi"
alias tbl="toolbox list"

function tbc {
  if [[ -n "$TOOLBOX_DEFAULT_IMAGE" ]]; then
    toolbox create --image $TOOLBOX_DEFAULT_IMAGE "$@"
  else
    toolbox create "$@"
  fi
}

function tbe {
  local TOOLBOX_NAME=$(toolbox_name)

  if [[ -n "$1" ]]; then
    TOOLBOX_NAME=$1
  elif [[ -z "$TOOLBOX_NAME" ]]; then
    TOOLBOX_NAME="$TOOLBOX_DEFAULT_CONTAINER"
  fi

  if ! podman container exists "$TOOLBOX_NAME"; then
    tbc "$TOOLBOX_NAME"
  fi

  toolbox --container "$TOOLBOX_NAME" run sudo hostname "$TOOLBOX_NAME"
  toolbox enter "$TOOLBOX_NAME"
}

function tbr {
  local TOOLBOX_NAME=$(toolbox_name)

  if podman container exists "$1"; then
    TOOLBOX_NAME=$1
    shift
  elif [[ -z "$TOOLBOX_NAME" ]]; then
    TOOLBOX_NAME=$TOOLBOX_DEFAULT_CONTAINER
  fi

  toolbox --container "$TOOLBOX_NAME" run sudo hostname "$TOOLBOX_NAME"
  toolbox --container "$TOOLBOX_NAME" run "$@"
}
