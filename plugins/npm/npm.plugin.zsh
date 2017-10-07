(( $+commands[npm] )) && {
  
  # Check if ZSH_CACHE_DIR is set.
  # If not, proceeds to find any existing directories containing npm_completion.
  # If can't find any, defaults to ZSH_CACHE_DEFAULT_DIR and sets ZSH_CACHE_DIR accordingly.
  if [ !${ZSH_CACHE_DIR} ]; then
    
    # Default cache directory in case none was found containing npm_completion file.
    ZSH_CACHE_DEFAULT_DIR="${HOME}/.oh-my-zsh/cache"

    # List of directories to look for npm_completion file.
    ZSH_CACHE_POSSIBLE_DIR=(
      "${HOME}/.oh-my-zsh/cache"
      "${HOME}/.zsh/cache"
      "${HOME}/.antigen/bundles/robbyrussell/oh-my-zsh/cache"
      "${HOME}/.tmp/cache"
      )
    
    # Loop list of possible cache directories containing npm_completion file
    # and set ZSH_CACHE_DIR to the first found.
    for d in "${ZSH_CACHE_POSSIBLE_DIR[@]}"; do
      # Exits loop if previous iteration already found an existing ${d}/npm_completion
      # & already set ZSH_CACHE_DIR to ${d}.
      [ ${ZSH_CACHE_DIR} ] && break

      # If current exists then sets ZSH_CACHE_DIR to it
      [ -f "${d}/npm_completion" ] && ZSH_CACHE_DIR=${d}
    done

    # If ZSH_CACHE_DIR still not set, then set to ZSH_CACHE_DEFAULT_DIR.
    [ -z ${ZSH_CACHE_DIR} ] && ZSH_CACHE_DIR=${ZSH_CACHE_DEFAULT_DIR}
  fi

    __NPM_COMPLETION_FILE="${ZSH_CACHE_DIR}/npm_completion"

    if [ ! -f $__NPM_COMPLETION_FILE ]; then
        npm completion >! $__NPM_COMPLETION_FILE 2>/dev/null
        [ $? -ne 0 ] && rm -f $__NPM_COMPLETION_FILE
    fi

    [ -f $__NPM_COMPLETION_FILE ] && source $__NPM_COMPLETION_FILE

    unset __NPM_COMPLETION_FILE
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

# Run npm start
alias npmst="npm start"

# Run npm test
alias npmt="npm test"
