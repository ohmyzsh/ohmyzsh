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

# Force npm to fetch remote resources even if a local copy exists on disk.
alias npmF='npm i -f'

# Execute command from node_modules folder based on current directory
# i.e npmE gulp
alias npmE='PATH="$(npm bin)":"$PATH"'

# Check which npm modules are outdated
alias npmO="npm outdated"

# Update all the packages listed to the latest version
alias npmU="npm update"

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

# Run npm info
alias npmi="npm info"

# Run npm search
alias npmSe="npm search"

_npm_buffer_editor() {
  if [[ "$1" == *"npm install"* ]]; then
    BUFFER=$(sed -e "s/npm install/npm uninstall/g" <<< $1)
  elif [[ "$1" == *"npm i"* ]]; then
    BUFFER=$(sed -e "s/npm i/npm uninstall/g" <<< $1)
  elif [[ "$1" == *"npm uninstall"* ]]; then
    BUFFER=$(sed -e "s/npm uninstall/npm install/g" <<< $1)
  fi
}

npm_install_uninstall_toggle() {
  local prev_line="$(fc -ln -1)"
  local line2="$(fc -ln -2 -2)"
  local curr_buffer=$BUFFER
  if [[ -z $BUFFER && "$prev_line" =~ "npm install|npm i|npm uninstall" ]]; then
    _npm_buffer_editor "$prev_line"
  elif [[ "$curr_buffer" =~ "npm install|npm i|npm uninstall" ]]; then
    _npm_buffer_editor "$curr_buffer"
  elif [[ "$line2" =~ "npm install|npm i|npm uninstall" ]]; then
    _npm_buffer_editor "$line2"
  else
    BUFFER="npm install"
  fi
}

zle -N npm_install_uninstall_toggle
# Defined shortcut keys: [F2] [F2]
# TIP: to pick a new bindkey use `sed -n l` to log key inputs.
bindkey -M emacs '^[OQ^[OQ' npm_install_uninstall_toggle
bindkey -M vicmd '^[OQ^[OQ' npm_install_uninstall_toggle
bindkey -M viins '^[OQ^[OQ' npm_install_uninstall_toggle