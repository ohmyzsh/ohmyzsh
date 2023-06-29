# This plugin loads nodenv into the current shell and provides prompt info via
# the 'nodenv_prompt_info' function.

FOUND_NODENV=${+commands[nodenv]}

if [[ $FOUND_NODENV -ne 1 ]]; then
  nodenvdirs=(
    "$HOME/.nodenv"
    "/usr/local/nodenv"
    "/opt/nodenv"
    "/usr/local/opt/nodenv"
  )
  for dir in $nodenvdirs; do
    if [[ -d "${dir}/bin" ]]; then
      export PATH="$PATH:${dir}/bin"
      FOUND_NODENV=1
      break
    fi
  done

  if [[ $FOUND_NODENV -ne 1 ]]; then
    if (( $+commands[brew] )) && dir=$(brew --prefix nodenv 2>/dev/null); then
      if [[ -d "${dir}/bin" ]]; then
        export PATH="$PATH:${dir}/bin"
        FOUND_NODENV=1
      fi
    fi
  fi
fi

if [[ $FOUND_NODENV -eq 1 ]]; then
  eval "$(nodenv init --no-rehash - zsh)"
  function nodenv_prompt_info() {
    nodenv version-name 2>/dev/null
  }
else
  # fallback to system node
  function nodenv_prompt_info() {
    echo "system: $(node -v 2>&1 | cut -c 2-)"
  }
fi

unset FOUND_NODENV nodenvdirs dir
