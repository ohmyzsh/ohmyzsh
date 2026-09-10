# This plugin loads goenv into the current shell.

# Load goenv only if command not already available
if command -v goenv &> /dev/null && [[ "$(uname -r)" != *icrosoft* ]]; then
  FOUND_GOENV=1
else
  FOUND_GOENV=0
fi

if [[ $FOUND_GOENV -ne 1 ]]; then
  goenvdirs=("$HOME/.goenv" "/usr/local/goenv" "/opt/goenv" "/usr/local/opt/goenv")
  for dir in $goenvdirs; do
    if [[ -d $dir/bin ]]; then
      export PATH="$PATH:$dir/bin"
      FOUND_GOENV=1
      break
    fi
  done
fi

if [[ $FOUND_GOENV -ne 1 ]]; then
  if (( $+commands[brew] )) && dir=$(brew --prefix goenv 2>/dev/null); then
    if [[ -d $dir/bin ]]; then
      export PATH="$PATH:$dir/bin"
      FOUND_GOENV=1
    fi
  fi
fi

if [[ $FOUND_GOENV -eq 1 ]]; then
  eval "$(goenv init -)"
  function goenv_prompt_info() {
    echo "$(goenv version-name)"
  }
else
  # fallback to system python
  function goenv_prompt_info() {
    echo "system: $(go verson 2>&1 | cut -f 3 -d ' ')"
  }
fi

unset FOUND_GOENV goenvdirs dir
