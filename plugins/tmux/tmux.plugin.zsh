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
    # if ! tmux has -t $1 2>/dev/null; then
    if ! tmux has -t $1; then
      TMUX= tmux new -ds $1 ${cmd-$2}
    fi

    # switch or attach depending on if we're inside tmux
    [[ -n $TMUX ]] && tmux switch -t $1 \
                   || tmux attach -t $1
  }
else
  omz_log_mgs "tmux: plugin requires tmux"
fi
