# Set NVM_DIR if it isn't already defined
[[ -z "$NVM_DIR" ]] && export NVM_DIR="$HOME/.nvm"

# Don't try to load nvm if command already available
type "nvm" &> /dev/null && return

# Load nvm if it exists in $NVM_DIR
if [[ -f "$NVM_DIR/nvm.sh" ]]; then
    source "$NVM_DIR/nvm.sh"
    return
fi

# Otherwise try to load nvm installed via Homebrew

# User can set this if they have an unusual Homebrew setup
NVM_HOMEBREW="${NVM_HOMEBREW:-/usr/local/opt/nvm}"
# Load nvm from Homebrew location if it exists
[[ -f "$NVM_HOMEBREW/nvm.sh" ]] && source "$NVM_HOMEBREW/nvm.sh"
# Load nvm bash completion from Homebrew if it exists
if [[ -f "$NVM_HOMEBREW/etc/bash_completion.d/nvm" ]]; then
    autoload -U +X bashcompinit && bashcompinit
    source "$NVM_HOMEBREW/etc/bash_completion.d/nvm"
fi
