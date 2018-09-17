# Set NVM_DIR if it isn't already defined
[[ -z "$NVM_DIR" ]] && export NVM_DIR="$HOME/.nvm"

# Load nvm if it exists, but without use
[[ -f "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" --no-use 

# Alias hack
alias node='unalias node ; unalias npm ; nvm use default ; node $@'
alias npm='unalias node ; unalias npm ; nvm use default ; npm $@'
