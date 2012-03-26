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
# Warning:
#   Tmux is known to cause kernel panics on Mac OS X.
#   For more information, see http://git.io/jkPqHg.
#

# Aliases
alias ta="tmux attach-session"
alias tl="tmux list-sessions"

# Auto Start
if [[ -z "$TMUX" ]] && zstyle -t ':omz:plugin:tmux:auto' start; then
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

