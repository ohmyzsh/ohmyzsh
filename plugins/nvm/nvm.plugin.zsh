# Set NVM_DIR if it isn't already defined
[[ -z "$NVM_DIR" ]] && export NVM_DIR="$HOME/.nvm"

# Try to load nvm only if command not already available
if ! type "nvm" &> /dev/null; then
    # Load nvm if it exists
    if [[ -f "$NVM_DIR/nvm.sh" ]];
        source "$NVM_DIR/nvm.sh"
    else
        # Load nvm from Homebrew location if it exists
        [[ -z "$NVM_HOMEBREW" ]] && export NVM_HOMEBREW="/usr/local/opt/nvm"
        [[ -f "$NVM_HOMEBREW/nvm.sh" ]] && source "$NVM_HOMEBREW/nvm.sh"
    fi
fi
