# Enable autostarting of tmux with:
#
#   zstyle :omz:plugins:tmux autostart on
#

if (( $+commands[tmux] )); then
  local state

  zstyle -a :omz:plugins:autostart state
  [[ state == "on" && -z $TMUX ]] && exec tmux

  # start an irc client in a tmux session
  if [[ -n $IRC ]]; then
    irc() {
      if tmux has -t irc >/dev/null; then
        [[ -n $TMUX ]] && tmux switch -t irc || tmux attach -t irc
      else
        TMUX="" tmux new -ds irc $IRC[1]
        [[ -n $TMUX ]] && tmux switch -t irc || tmux attach -t irc
      fi
    }
  fi

  # start rtorrent in a tmux session
  if [[ -n $RTORRENT ]]; then
    torrents() {
      if tmux has -t torrents >/dev/null; then
        [[ -n $TMUX ]] && tmux switch -t torrents || tmux attach -t torrents
      else
        TMUX="" tmux new -ds torrents $RTORRENT[1]
        [[ -n $TMUX ]] && tmux switch -t torrents || tmux attach -t torrents
      fi
    }
  fi
else
  omz_log_mgs "notfound: plugin requires tmux"
fi
