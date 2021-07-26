# This plugin loads pyenv into the current shell and provides prompt info via
# the 'pyenv_prompt_info' function. Also loads pyenv-virtualenv if available.

# Look for pyenv in $PATH and verify that it's not a part of pyenv-win in WSL
if ! command -v pyenv &>/dev/null; then
  FOUND_PYENV=0
elif [[ "${commands[pyenv]}" = */pyenv-win/* && "$(uname -r)" = *icrosoft* ]]; then
  FOUND_PYENV=0
else
  FOUND_PYENV=1
fi

# Look for pyenv and try to load it (will only work on interactive shells)
if [[ $FOUND_PYENV -ne 1 ]]; then
  pyenvdirs=("$HOME/.pyenv" "/usr/local/pyenv" "/opt/pyenv" "/usr/local/opt/pyenv")
  for dir in $pyenvdirs; do
    if [[ -d "$dir/bin" ]]; then
      FOUND_PYENV=1
      break
    fi
  done

  if [[ $FOUND_PYENV -ne 1 ]]; then
    if (( $+commands[brew] )) && dir=$(brew --prefix pyenv 2>/dev/null); then
      if [[ -d "$dir/bin" ]]; then
        FOUND_PYENV=1
      fi
    fi
  fi

  # If we found pyenv, load it but show a caveat about non-interactive shells
  if [[ $FOUND_PYENV -eq 1 ]]; then
    cat <<EOF
Found pyenv, but it is badly configured. pyenv might not work for
non-interactive shells (for example, when run from a script).
${bold_color}
To fix this message, add these lines to the '.profile' and '.zprofile' files
in your home directory:

export PYENV_ROOT="${dir/#$HOME/\$HOME}"
export PATH="\$PYENV_ROOT/bin:\$PATH"
eval "\$(pyenv init --path)"
${reset_color}
For more info go to https://github.com/pyenv/pyenv/#installation.
EOF

    # Configuring in .zshrc only makes pyenv available for interactive shells
    export PYENV_ROOT=$dir
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
  fi
fi

if [[ $FOUND_PYENV -eq 1 ]]; then
  eval "$(pyenv init - --no-rehash zsh)"

  if (( ${+commands[pyenv-virtualenv-init]} )); then
    eval "$(pyenv virtualenv-init - zsh)"
  fi

  function pyenv_prompt_info() {
    echo "$(pyenv version-name)"
  }
else
  # Fall back to system python
  function pyenv_prompt_info() {
    echo "system: $(python -V 2>&1 | cut -f 2 -d ' ')"
  }
fi

unset FOUND_PYENV pyenvdirs dir
