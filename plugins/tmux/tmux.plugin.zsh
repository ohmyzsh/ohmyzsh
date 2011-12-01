# Enable autostarting of tmux with:
#
#   zstyle :omz:plugins:tmux autostart on
#

if (( $+commands[tmux] )); then
  local state

  zstyle -a :omz:plugins:autostart state
  [[ state == "on" && -z $TMUX ]] && exec tmux

  if [[ -n $IRC ]]; then
    irc() {
      if tmux has -t irc >/dev/null; then
        tmux switch -t irc
      else
        TMUX="" tmux new -ds irc $IRC[1]
        tmux switch -t irc
      fi
    }
  fi
else
  omz_log_mgs "notfound: plugin requires tmux"
fi
