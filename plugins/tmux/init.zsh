# ------------------------------------------------------------------------------
#          FILE:  tmux.plugin.zsh
#   DESCRIPTION:  oh-my-zsh plugin file.
#        AUTHOR:  Sorin Ionescu <sorin.ionescu@gmail.com>
#       VERSION:  1.0.0
# ------------------------------------------------------------------------------

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

