# Don't try to load nvm if command already available
# Note: nvm is a function so we need to use `which`
which nvm &>/dev/null && return

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

if [[ -z "$NVM_DIR" ]] || [[ ! -f "$NVM_DIR/nvm.sh" ]]; then
  return
fi

function _omz_load_nvm_completion {
  local _nvm_completion
  # Load nvm bash completion
  for _nvm_completion in "$NVM_DIR/bash_completion" "$NVM_HOMEBREW/etc/bash_completion.d/nvm"; do
    if [[ -f "$_nvm_completion" ]]; then
      # Load bashcompinit
      autoload -U +X bashcompinit && bashcompinit
      # Bypass compinit call in nvm bash completion script. See:
      # https://github.com/nvm-sh/nvm/blob/4436638/bash_completion#L86-L93
      ZSH_VERSION= source "$_nvm_completion"
      break
    fi
  done
  unfunction _omz_load_nvm_completion
}

function _omz_setup_autoload {
  if ! zstyle -t ':omz:plugins:nvm' autoload; then
    unfunction _omz_setup_autoload
    return
  fi

  # Autoload nvm when finding a .nvmrc file in the current directory
  # Adapted from: https://github.com/nvm-sh/nvm#zsh
  function load-nvmrc {
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
    elif [[ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ]] && [[ "$(nvm version)" != "$(nvm version default)" ]]; then
      [[ -z $nvm_silent ]] && echo "Reverting to nvm default version"

      nvm use default $nvm_silent
    fi
  }

  autoload -U add-zsh-hook
  add-zsh-hook chpwd load-nvmrc

  load-nvmrc
  unfunction _omz_setup_autoload
}

if zstyle -t ':omz:plugins:nvm' lazy; then
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
      _omz_load_nvm_completion
      _omz_setup_autoload
      \"\$0\" \"\$@\"
    }
  "
  unset nvm_lazy_cmd
else
  source "$NVM_DIR/nvm.sh"
  _omz_load_nvm_completion
  _omz_setup_autoload
fi
