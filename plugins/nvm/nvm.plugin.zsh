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

# TODO: 2022-11-11: Remove soft-deprecate options
if (( ${+NVM_LAZY} + ${+NVM_LAZY_CMD} + ${+NVM_AUTOLOAD} )); then
  # Get list of NVM_* variable settings defined
  local -a used_vars
  used_vars=(${(o)parameters[(I)NVM_(AUTOLOAD|LAZY|LAZY_CMD)]})
  # Nicely print the list in the style `var1, var2 and var3`
  echo "${fg[yellow]}[nvm plugin] Variable-style settings are deprecated. Instead of ${(j:, :)used_vars[1,-2]}${used_vars[-2]+ and }${used_vars[-1]}, use:\n"
  if (( $+NVM_AUTOLOAD )); then
    echo "  zstyle ':omz:plugins:nvm' autoload yes"
    zstyle ':omz:plugins:nvm' autoload yes
  fi
  if (( $+NVM_LAZY )); then
    echo "  zstyle ':omz:plugins:nvm' lazy yes"
    zstyle ':omz:plugins:nvm' lazy yes
  fi
  if (( $+NVM_LAZY_CMD )); then
    echo "  zstyle ':omz:plugins:nvm' lazy-cmd $NVM_LAZY_CMD"
    zstyle ':omz:plugins:nvm' lazy-cmd $NVM_LAZY_CMD
  fi
  echo "$reset_color"
  unset used_vars NVM_AUTOLOAD NVM_LAZY NVM_LAZY_CMD
fi

if zstyle -t ':omz:plugins:nvm' lazy; then
  # Call nvm when first using nvm, node, npm, pnpm, yarn or other commands in lazy-cmd
  zstyle -a ':omz:plugins:nvm' lazy-cmd nvm_lazy_cmd
  eval "
    function nvm node npm pnpm yarn $nvm_lazy_cmd {
      unfunction nvm node npm pnpm yarn $nvm_lazy_cmd
      # Load nvm if it exists in \$NVM_DIR
      [[ -f \"\$NVM_DIR/nvm.sh\" ]] && source \"\$NVM_DIR/nvm.sh\"
      \"\$0\" \"\$@\"
    }
  "
  unset nvm_lazy_cmd
elif [[ -f "$NVM_DIR/nvm.sh" ]]; then
  # Load nvm if it exists in $NVM_DIR
  source "$NVM_DIR/nvm.sh"
else
  return
fi

# Autoload nvm when finding a .nvmrc file in the current directory
# Adapted from: https://github.com/nvm-sh/nvm#zsh
if zstyle -t ':omz:plugins:nvm' autoload; then
  function load-nvmrc {
    local node_version="$(nvm version)"
    local nvmrc_path="$(nvm_find_nvmrc)"
    local nvm_silent=""
    zstyle -t ':omz:plugins:nvm' silent-autoload && nvm_silent="--silent"

    if [[ -n "$nvmrc_path" ]]; then
      local nvmrc_node_version=$(nvm version $(cat "$nvmrc_path" | tr -dc '[:print:]'))

      if [[ "$nvmrc_node_version" = "N/A" ]]; then
        nvm install
      elif [[ "$nvmrc_node_version" != "$node_version" ]]; then
        nvm use $nvm_silent
      fi
    elif [[ "$node_version" != "$(nvm version default)" ]]; then
      if [[ -z $nvm_silent ]]; then
        echo "Reverting to nvm default version"
      fi

      nvm use default $nvm_silent
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

unset NVM_HOMEBREW nvm_completion
