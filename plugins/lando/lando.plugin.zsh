# Settings
: ${LANDO_ZSH_SITES_DIRECTORY:="$HOME/Sites"}
: ${LANDO_ZSH_CONFIG_FILE:=.lando.yml}
: ${LANDO_ZSH_WRAPPED_COMMANDS:="
  artisan
  composer
  drush
  gulp
  npm
  php
  wp
  yarn
"}

# Enable multiple commands with lando.
function ${=LANDO_ZSH_WRAPPED_COMMANDS} {
  # If the lando task is available in `lando --help`, then it means:
  #
  # 1. `lando` is in a project with a `.lando.yml` file.
  # 2. The lando task is available for lando, based on the .lando.yml config file.
  #
  # This has a penalty of about 250ms, so we still want to check if the lando file
  # exists before, which is the fast path. If it exists, checking help output is
  # still faster than running the command and failing.
  if _lando_file_exists && lando --help 2>&1 | command grep -Eq "^ +lando $0 "; then
    command lando "$0" "$@"
  else
    command "$0" "$@"
  fi
}

# Check for the file in the current and parent directories.
_lando_file_exists() {
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
