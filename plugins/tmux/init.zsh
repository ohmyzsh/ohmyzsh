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
  tmux_session='#OMZ'

  if ! tmux has-session -t "$tmux_session" 2> /dev/null; then
    # Disable the destruction of unattached sessions globally.
    tmux set-option -g destroy-unattached off &> /dev/null

    # Create a new session.
    tmux new-session -d -s "$tmux_session"

    # Disable the destruction of the new, unattached session.
    tmux set-option -t "$tmux_session" destroy-unattached off &> /dev/null

    # Enable the destruction of unattached sessions globally to prevent
    # an abundance of open, detached sessions.
    tmux set-option -g destroy-unattached on &> /dev/null
  fi

  exec tmux new-session -t "$tmux_session"
fi

