# Settings
: ${LANDO_ZSH_SITES_DIRECTORY:="$HOME/Sites"}
: ${LANDO_ZSH_CONFIG_FILE:=.lando.yml}

# Enable multiple commands with lando.
function artisan \
         composer \
         drush \
         gulp \
         npm \
         php \
         wp \
         yarn {
  if checkForLandoFile; then
    lando "$0" "$@"
  else
    command "$0" "$@"
  fi
}

# Check for the file in the current and parent directories.
checkForLandoFile() {
  # Only bother checking for lando within the Sites directory.
  if [[ "$PWD/" != "$LANDO_ZSH_SITES_DIRECTORY"/* ]]; then
    # Not within $LANDO_ZSH_SITES_DIRECTORY
    return 1
  fi

  local curr_dir="$PWD"
  # Checking for file: $LANDO_ZSH_CONFIG_FILE within $LANDO_ZSH_SITES_DIRECTORY...
  while [[ "$curr_dir" != "$LANDO_ZSH_SITES_DIRECTORY" ]]; do
    if [[ -f "$curr_dir/$LANDO_ZSH_CONFIG_FILE" ]]; then
      return 0
    fi
    curr_dir="${curr_dir:h}"
  done

  # Could not find $LANDO_ZSH_CONFIG_FILE in the current directory
  # or in any of its parents up to $LANDO_ZSH_SITES_DIRECTORY.
  return 1
}