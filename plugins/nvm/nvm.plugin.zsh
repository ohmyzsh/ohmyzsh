# Set NVM_DIR if it isn't already defined
[[ -z "$NVM_DIR" ]] && export NVM_DIR="$HOME/.nvm"

# https://github.com/nvm-sh/nvm#installation-and-update
if [[ ! -d "$NVM_DIR/" && -d "${XDG_CONFIG_HOME:-$HOME/.config}/nvm/" ]]; then
	export NVM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvm"
fi

# Try to load nvm only if command not already available
if ! type "nvm" &> /dev/null; then
    # Load nvm if it exists
    [[ -f "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
fi
