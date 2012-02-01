#
# Loads Compleat completions.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

if (( ${+commands[compleat]} )); then
  compleat_setup="${commands[compleat]:h:h}/share/compleat-1.0/compleat_setup"

  if [[ -f "$compleat_setup" ]]; then
    if autoloadable bashcompinit; then
      autoload -Uz bashcompinit && bashcompinit
    fi

    source "$compleat_setup"
    unset compleat_setup
  fi
fi

