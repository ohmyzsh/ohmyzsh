#
# Defines GNU Screen aliases and provides for auto launching it at startup.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Aliases
alias sl="screen -list"
alias sn="screen -U -S"
alias sr="screen -a -A -U -D -R"

# Auto
if (( $SHLVL == 1 )) && is-true "$AUTO_SCREEN"; then
  (( SHLVL += 1 )) && export SHLVL
  session="$(screen -list 2> /dev/null | sed '1d;$d' | awk '{print $1}' | head -1)"
  if [[ -n "$session" ]]; then
    exec screen -x "$session"
  else
    exec screen -a -A -U -D -R -m "$SHELL" -l
  fi
fi

