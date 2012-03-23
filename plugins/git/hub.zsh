#
# Adds GitHub knowledge to the Git command.
#
# Authors:
#   Chris Wanstrath <chris@wanstrath.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

if (( $+commands[hub] )); then
  function git {
    hub "$@"
  }
fi

