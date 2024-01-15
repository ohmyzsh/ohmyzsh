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

if [[ -z "$NVM_DIR" ]] || [[ ! -f "$NVM_DIR/nvm.sh" ]]; then 
  return
fi

if zstyle -t ':omz:plugins:nvm' lazy && \
  ! zstyle -t ':omz:plugins:nvm' autoload; then
  # Call nvm when first using nvm, node, npm, pnpm, yarn or other commands in lazy-cmd
  zstyle -a ':omz:plugins:nvm' lazy-cmd nvm_lazy_cmd
  nvm_lazy_cmd=(nvm node npm npx pnpm yarn $nvm_lazy_cmd) # default values
  eval "
    function $nvm_lazy_cmd {
      for func in $nvm_lazy_cmd; do
        if (( \$+functions[\$func] )); then
          unfunction \$func
        fi
      done
      # Load nvm if it exists in \$NVM_DIR
      [[ -f \"\$NVM_DIR/nvm.sh\" ]] && source \"\$NVM_DIR/nvm.sh\"
      \"\$0\" \"\$@\"
    }
  "
  unset nvm_lazy_cmd
else
  source "$NVM_DIR/nvm.sh"
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
