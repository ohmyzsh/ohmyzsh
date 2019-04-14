# Set NVM_DIR if it isn't already defined
[[ -z "$NVM_DIR" ]] && export NVM_DIR="$HOME/.nvm"

# Try to load nvm only if command not already available
if ! type "nvm" &> /dev/null; then
    # Load nvm if it exists
    if command -v brew &> /dev/null && [ -s $(brew --prefix nvm)/nvm.sh ]; then
      source $(brew --prefix nvm)/nvm.sh
    else
      [[ -f "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    fi
fi