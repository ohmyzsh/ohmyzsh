# See https://github.com/nvm-sh/nvm#installation-and-update
if [[ -z "$NVM_DIR" ]]; then
  if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
  elif [[ -d "${XDG_CONFIG_HOME:-$HOME/.config}/nvm" ]]; then
    export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
  fi
fi

# Don't try to load nvm if command already available
which nvm &> /dev/null && return

if [[ -f "$NVM_DIR/nvm.sh" ]]; then
  # Load nvm if it exists in $NVM_DIR
  source "$NVM_DIR/nvm.sh" --no-use
else
  # Otherwise try to load nvm installed via Homebrew
  # User can set this if they have an unusual Homebrew setup
  NVM_HOMEBREW="${NVM_HOMEBREW:-/usr/local/opt/nvm}"
  # Load nvm from Homebrew location if it exists
  [[ -f "$NVM_HOMEBREW/nvm.sh" ]] && source "$NVM_HOMEBREW/nvm.sh" --no-use
fi

# Call nvm when first using node, npm or yarn
function node npm yarn {
  unfunction node npm yarn
  nvm use default
  command "$0" "$@"
}

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
