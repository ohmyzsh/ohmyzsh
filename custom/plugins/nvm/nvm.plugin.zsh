# The addition 'nvm install' attempts in ~/.profile

if [ -s ~/.nvm/nvm.sh ]; then
    . $HOME/.nvm/nvm.sh

    # Check if the NODE_VERSION environment variable is set,
    # if so trigger nvm to use this.
    if [[ $NODE_VERSION != "" ]]; then
        nvm use $NODE_VERSION > /dev/null
    fi
fi
