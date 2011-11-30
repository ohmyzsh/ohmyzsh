# TODO: move elsewhere
IRC=($commands[weechat-curses] $commands[irssi])

if (( $+commands[tmux] )); then
  [[ -z $TMUX ]] && exec tmux

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
fi
