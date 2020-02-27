# Set NVM_DIR if it isn't already defined
[[ -z "$NVM_DIR" ]] && export NVM_DIR="$HOME/.nvm"

# Try to load nvm only if command not already available
if ! type "nvm" &> /dev/null; then
    # Load nvm if it exists
    [[ -f "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
fi
