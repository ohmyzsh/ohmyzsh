#
# Defines tmux aliases and provides for auto launching it at startup.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Aliases
alias ta="tmux attach-session"
alias tl="tmux list-sessions"

# Auto
if (( $SHLVL == 1 )) && is-true "$AUTO_TMUX"; then
  (( SHLVL += 1 )) && export SHLVL
  session="$(tmux list-sessions 2> /dev/null | cut -d':' -f1 | head -1)"
  if [[ -n "$session" ]]; then
    exec tmux attach-session -t "$session"
  else
    exec tmux new-session "$SHELL -l"
  fi
fi

