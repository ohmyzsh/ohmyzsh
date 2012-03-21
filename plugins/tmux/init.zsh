#
# Defines tmux aliases and provides for auto launching it at start-up.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
# Usage:
#   To auto start it, add the following to zshrc:
#
#     # Auto launch tmux at start-up.
#     zstyle -t ':omz:plugin:tmux:auto' start 'yes'
#

# Aliases
alias ta="tmux attach-session"
alias tl="tmux list-sessions"

# Auto Start
if (( $SHLVL == 1 )) && zstyle -t ':omz:plugin:tmux:auto' start; then
  session="$(
    tmux list-sessions 2> /dev/null \
      | cut -d':' -f1 \
      | head -1)"

  if [[ -n "$session" ]]; then
    exec tmux attach-session -t "$session"
  else
    exec tmux new-session
  fi
fi

