# Enable autostarting of tmux with:
#   zstyle :omz:plugins:tmux autostart on
#
# Configure t command to autostart a command like
# this (example for "t irc"):
#   zstyle :omz:plugins:cmd irc weechat-curses
#

if (( $+commands[tmux] )); then
  local state

  # autoload tmux on start
  zstyle -a :omz:plugins:tmux autostart state
  [[ $state == "on" && -z $TMUX ]] && exec tmux

  t() {
    #load the command from config
    zstyle -a :omz:plugins:tmux:cmd $1 cmd
    (( $+commands[$cmd] )) || return 127

    # start the command
    if ! tmux has -t $1 2>/dev/null; then
      TMUX= tmux new -ds $1 ${cmd-$2}
    fi

    # switch or attach depending on if we're inside tmux
    [[ -n $TMUX ]] && tmux switch -t $1 \
                   || tmux attach -t $1
  }
else
  omz_log_mgs "tmux: plugin requires tmux"
fi
