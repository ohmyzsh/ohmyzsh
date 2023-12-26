(( $+commands[npm] )) && {
  command rm -f "${ZSH_CACHE_DIR:-$ZSH/cache}/npm_completion"

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

# Run npm run dev
alias npmrd="npm run dev"

# Run npm run build
alias npmrb="npm run build"

npm_toggle_install_uninstall() {
  # Look up to the previous 2 history commands
  local line
  for line in "$BUFFER" \
    "${history[$((HISTCMD-1))]}" \
    "${history[$((HISTCMD-2))]}"
  do
    case "$line" in
      "npm uninstall"*)
        BUFFER="${line/npm uninstall/npm install}"
        (( CURSOR = CURSOR + 2 )) # uninstall -> install: 2 chars removed
        ;;
      "npm install"*)
        BUFFER="${line/npm install/npm uninstall}"
        (( CURSOR = CURSOR + 2 )) # install -> uninstall: 2 chars added
        ;;
      "npm un "*)
        BUFFER="${line/npm un/npm install}"
        (( CURSOR = CURSOR + 5 )) # un -> install: 5 chars added
        ;;
      "npm i "*)
        BUFFER="${line/npm i/npm uninstall}"
        (( CURSOR = CURSOR + 8 )) # i -> uninstall: 8 chars added
        ;;
      *) continue ;;
    esac
    return 0
  done

  BUFFER="npm install"
  CURSOR=${#BUFFER}
}

zle -N npm_toggle_install_uninstall

# Defined shortcut keys: [F2] [F2]
bindkey -M emacs '^[OQ^[OQ' npm_toggle_install_uninstall
bindkey -M vicmd '^[OQ^[OQ' npm_toggle_install_uninstall
bindkey -M viins '^[OQ^[OQ' npm_toggle_install_uninstall
