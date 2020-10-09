LANDO_ZSH_SITES_DIRECTORY="$HOME/Sites"

LANDO_ZSH_CONFIG_FILE=.lando.yml

# Enable multiple commands with lando.
function  artisan \
          composer \
          drush \
          gulp \
          npm \
          wp \
          yarn {

  if checkForFile ; then
    lando "$0" "$@"
  else
    command "$0" "$@"
  fi
}

# Check for the file in the current and parent directories.
checkForFile(){

  local current_directory="$PWD"

  # Bash is backwards. 0 is true 1 (non-zero) is false.
  # Only bother checking for lando within the Sites directory.
  if [[ "$PWD/" != "$LANDO_ZSH_SITES_DIRECTORY"/* ]]; then

    # Not within $LANDO_ZSH_SITES_DIRECTORY
    return 1;

  else

    # "Checking for file: $LANDO_ZSH_CONFIG_FILE within $LANDO_ZSH_SITES_DIRECTORY..."

    while [[ "$current_directory" != $LANDO_ZSH_SITES_DIRECTORY ]]; do

        if [[ -f "$current_directory/$LANDO_ZSH_CONFIG_FILE" ]]; then
          # echo "Using Lando"
          return
        fi
        current_directory="${current_directory:h}"
        
    done

    # File not found in loop above
    # "Could not find $LANDO_ZSH_CONFIG_FILE in the current directory or in any of its parents up to $LANDO_ZSH_SITES_DIRECTORY."
    return 1

  fi
}
