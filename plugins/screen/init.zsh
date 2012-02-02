#
# Defines GNU Screen aliases and provides for auto launching it at start-up.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
# Usage:
#   To auto start it, add the following to zshrc:
#
#     # Auto launch GNU Screen at start-up.
#     zstyle -t ':omz:plugin:screen:auto' start 'yes'
#

# Aliases
alias sl="screen -list"
alias sn="screen -U -S"
alias sr="screen -a -A -U -D -R"

# Auto Start
if (( $SHLVL == 1 )) && zstyle -t ':omz:plugin:screen:auto' start; then
  (( SHLVL += 1 )) && export SHLVL

  session="$(
    screen -list 2> /dev/null \
      | sed '1d;$d' \
      | awk '{print $1}' \
      | head -1)"

  if [[ -n "$session" ]]; then
    exec screen -x "$session"
  else
    exec screen -a -A -U -D -R -m "$SHELL" -l
  fi
fi

