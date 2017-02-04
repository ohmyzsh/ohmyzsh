# if homebrew installed
_homebrew-installed() {
    type brew &> /dev/null
}

# if nvm from homebrew installed
_nvm-from-homebrew-installed() {
    brew --prefix nvm &> /dev/null
}

# Set NVM_DIR if it isn't already defined
[[ -z "$NVM_DIR" ]] && export NVM_DIR="$HOME/.nvm"

# Load nvm if it exists
if [[ -f "$NVM_DIR/nvm.sh" ]] ; then
    source "$NVM_DIR/nvm.sh"
elif _homebrew-installed && _nvm-from-homebrew-installed ; then
    source "$(brew --prefix nvm)/nvm.sh"
else
    unset NVM_DIR
fi
