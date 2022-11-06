# See https://github.com/nvm-sh/nvm#installation-and-update
if [[ -z "$NVM_DIR" ]]; then
  if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
  elif [[ -d "${XDG_CONFIG_HOME:-$HOME/.config}/nvm" ]]; then
    export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
  elif (( $+commands[brew] )); then
    NVM_HOMEBREW="${NVM_HOMEBREW:-${HOMEBREW_PREFIX:-$(brew --prefix)}/opt/nvm}"
    if [[ -d "$NVM_HOMEBREW" ]]; then
      export NVM_DIR="$NVM_HOMEBREW"
    fi
  fi
fi

# Don't try to load nvm if command already available
# Note: nvm is a function so we need to use `which`
which nvm &>/dev/null && return

if (( $+NVM_LAZY )); then
  # Call nvm when first using nvm, node, npm, pnpm, yarn or $NVM_LAZY_CMD
  function nvm node npm pnpm yarn $NVM_LAZY_CMD {
    unfunction nvm node npm pnpm yarn $NVM_LAZY_CMD
    # Load nvm if it exists in $NVM_DIR
    [[ -f "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    "$0" "$@"
  }
elif [[ -f "$NVM_DIR/nvm.sh" ]]; then
  # Load nvm if it exists in $NVM_DIR
  source "$NVM_DIR/nvm.sh"
else
  return
fi

# Autoload nvm when finding a .nvmrc file in the current directory
# Adapted from: https://github.com/nvm-sh/nvm#zsh
if (( $+NVM_AUTOLOAD )); then
  load-nvmrc() {
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"

    if [[ -n "$nvmrc_path" ]]; then
      local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

      if [[ "$nvmrc_node_version" = "N/A" ]]; then
        nvm install
      elif [[ "$nvmrc_node_version" != "$node_version" ]]; then
        nvm use
      fi
    elif [[ "$node_version" != "$(nvm version default)" ]]; then
      echo "Reverting to nvm default version"
      nvm use default
    fi
  }

  autoload -U add-zsh-hook
  add-zsh-hook chpwd load-nvmrc

  load-nvmrc
fi

# Load nvm bash completion
for nvm_completion in "$NVM_DIR/bash_completion" "$NVM_HOMEBREW/etc/bash_completion.d/nvm"; do
  if [[ -f "$nvm_completion" ]]; then
    # Load bashcompinit
    autoload -U +X bashcompinit && bashcompinit
    # Bypass compinit call in nvm bash completion script. See:
    # https://github.com/nvm-sh/nvm/blob/4436638/bash_completion#L86-L93
    ZSH_VERSION= source "$nvm_completion"
    break
  fi
done

unset NVM_HOMEBREW NVM_LAZY NVM_AUTOLOAD nvm_completion
