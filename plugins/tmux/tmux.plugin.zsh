# tmux plugin
# Copyright (C) 2011 Simon Gomizelj
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Enable autostarting of tmux with:
#   zstyle :omz:plugins:tmux autostart on
#
# Configure t command to autostart a command like
# this (example for "t irc"):
#   zstyle :omz:plugins:tmux:cmd irc weechat-curses
#
# Another example would be to start a new session in a directory. (example for "t git")
#   zstyle :omz:plugins:tmux:dir git $HOME/github
#

if (( $+commands[tmux] )); then
  local state

  # autoload tmux on start
  zstyle -a :omz:plugins:tmux autostart state
  [[ $state == "on" && -z $TMUX ]] && exec tmux

  t() {
    # Load the command or directory-path from config.
    zstyle -a :omz:plugins:tmux:cmd $1 cmd; cmd=${cmd:-$2}
    zstyle -a :omz:plugins:tmux:dir $1 dir
    [[ -n $cmd ]] && (( ! $+commands[$cmd] )) && return 127

    # start the command
    # if ! tmux has -t $1 2>/dev/null; then
    if ! tmux has -t $1; then
      (
        [[ -d $dir ]] && cd $dir
        TMUX= tmux new -ds $1 ${cmd:-$SHELL}
      )
    fi

    # switch or attach depending on if we're inside tmux
    [[ -n $TMUX ]] && tmux switch -t $1 \
                   || tmux attach -t $1
  }
else
  omz_log_mgs "tmux: plugin requires tmux"
fi
