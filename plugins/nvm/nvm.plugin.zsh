# Set NVM_DIR if it isn't already defined
if [[ -z "$NVM_DIR" ]]; then
	if [[ -z "$XDG_CONFIG_HOME" ]]; then
		export NVM_DIR="$HOME/.nvm"
	else
		export NVM_DIR="$XDG_CONFIG_HOME/nvm"
	fi
fi

# Try to load nvm only if command not already available
if ! type "nvm" &> /dev/null; then
    # Load nvm if it exists
    [[ -f "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" --no-use
fi
