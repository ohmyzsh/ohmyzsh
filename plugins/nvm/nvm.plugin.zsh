# Set NVM_DIR if it isn't already defined
[[ -z "$NVM_DIR" ]] && export NVM_DIR="$HOME/.nvm"

# Try to load nvm only if command not already available
if ! type "nvm" &> /dev/null; then
    # Load nvm if it exists
    if [[ -f "$NVM_DIR/nvm.sh" ]];
        source "$NVM_DIR/nvm.sh"
    else
        # User can set this if they have an unusual Homebrew setup
        [[ -z "$NVM_HOMEBREW" ]] && export NVM_HOMEBREW="/usr/local/opt/nvm"
        # Load nvm from Homebrew location if it exists
        [[ -f "$NVM_HOMEBREW/nvm.sh" ]] && source "$NVM_HOMEBREW/nvm.sh"
        # Load nvm bash completion from Homebrew location if it exists
        [[ -f "$NVM_HOMEBREW/etc/bash_completion.d/nvm" ]] && source "$NVM_HOMEBREW/etc/bash_completion.d/nvm"
    fi
fi
