# Set NVM_DIR if it isn't already defined
[[ -z "$NVM_DIR" ]] && export NVM_DIR="$HOME/.nvm"

if ! type "nvm" &> /dev/null; then
    # Load if it exists
    if [ ! -f "/usr/local/opt/nvm" ]; then
        # brew install nvm
        nvm_sh_dir="/usr/local/opt/nvm"
        # This loads nvm
        [ -s "${nvm_sh_dir}/nvm.sh" ] && . "${nvm_sh_dir}/nvm.sh"
        # This loads nvm bash_completion
        [ -s "${nvm_sh_dir}/etc/bash_completion.d/nvm" ] && . "${nvm_sh_dir}/etc/bash_completion.d/nvm"
    else
        # This loads nvm
        [[ -f "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    fi
fi
