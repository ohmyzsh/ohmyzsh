# Laravel Sail ZSH plugin
#
# Setting
: ${SAIL_ZSH_BIN_PATH:="./vendor/bin/sail"}

# Enable multiple commands with sail
function artisan \
         composer \
         node \
         npm \
         npx \
         php \
         yarn {
  if checkForSail; then
    $SAIL_ZSH_BIN_PATH "$0" "$@"
  else
    command "$0" "$@"
  fi
}

# Check for the file in the current and parent directories.
checkForSail() {
  # Check if ./vendor directory exists and if ./vendor/bin/sail file exists.
  if [ -f $SAIL_ZSH_BIN_PATH ]; then
    return 0
  else
    # Could not find $SAIL_ZSH_BIN_PATH in the current directory
    return 1
  fi
}
