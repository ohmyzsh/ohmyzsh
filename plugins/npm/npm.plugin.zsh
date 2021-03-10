(( $+commands[npm] )) && {
  rm -f "${ZSH_CACHE_DIR:-$ZSH/cache}/npm_completion"

  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
}

# Install dependencies globally
alias npmg="npm i -g "

# npm package names are lowercase
# Thus, we've used camelCase for the following aliases:

# Install and save to dependencies in your package.json
# npms is used by https://www.npmjs.com/package/npms
alias npmS="npm i -S "

# Install and save to dev-dependencies in your package.json
# npmd is used by https://github.com/dominictarr/npmd
alias npmD="npm i -D "

# Execute command from node_modules folder based on current directory
# i.e npmE gulp
alias npmE='PATH="$(npm bin)":"$PATH"'

# Check which npm modules are outdated
alias npmO="npm outdated"

# Check package versions
alias npmV="npm -v"

# List packages
alias npmL="npm list"

# List top-level installed packages
alias npmL0="npm ls --depth=0"

# Run npm start
alias npmst="npm start"

# Run npm test
alias npmt="npm test"

# Run npm scripts
alias npmR="npm run"

# Run npm publish 
alias npmP="npm publish"

# Run npm init
alias npmI="npm init"

npm-buffer-editor() {
    if [[ "$1" == *"npm install"* ]]; then
        BUFFER=$(sed -e "s/npm install/npm uninstall/g" <<< $1)
    elif [[ "$1" == *"npm i"* ]]; then
        BUFFER=$(sed -e "s/npm i/npm uninstall/g" <<< $1)
    elif [[ "$1" == *"npm uninstall"* ]]; then
        BUFFER=$(sed -e "s/npm uninstall/npm install/g" <<< $1)
    fi
}

npm-uninstall-install-toggle() {
    PREVLINE="$(fc -ln -1)"
    LINE2="$(fc -ln -2 -2)"
    CURRBUFFER=$BUFFER
    if [[ -z $BUFFER && "$PREVLINE" =~ "npm install|npm i|npm uninstall" ]]; then
        npm-buffer-editor "$PREVLINE"
    elif [[ "$CURRBUFFER" =~ "npm install|npm i|npm uninstall" ]]; then;
        npm-buffer-editor "$CURRBUFFER"
    elif [[ "$LINE2" =~ "npm install|npm i|npm uninstall" ]]; then;
        npm-buffer-editor "$LINE2"
    else
        BUFFER="npm install"
    fi
}

zle -N npm-uninstall-install-toggle
# Defined shortcut keys: [F1] [F1]
# TIP: to pick a new bindkey use `sed -n l` to log key inputs.
bindkey -M emacs '^[OP^[OP' npm-uninstall-install-toggle
bindkey -M vicmd '^[OP^[OP' npm-uninstall-install-toggle
bindkey -M viins '^[OP^[OP' npm-uninstall-install-toggle