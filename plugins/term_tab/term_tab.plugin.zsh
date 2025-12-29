# Copyright (C) 2014 Julian Vetter <death.jester@web.de>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

function _term_list(){
  local -a expl
  local -au dirs

  PREFIX="$IPREFIX$PREFIX"
  IPREFIX=
  SUFFIX="$SUFFIX$ISUFFIX"
  ISUFFIX=

  [[ -o magicequalsubst ]] && compset -P '*='

  case $OSTYPE in
    solaris*) dirs=( ${(M)${${(f)"$(pgrep -U $UID -x zsh|xargs pwdx)"}:#$$:*}%%/*} ) ;;
    linux*) dirs=( /proc/${^$(pidof zsh):#$$}/cwd(N:A) ) ;;
    darwin*) dirs=( $( lsof -d cwd -c zsh -a -w -Fn | sed -n 's/^n//p' ) ) ;;
  esac
  dirs=( ${(D)dirs} )

  compstate[pattern_match]='*'
  _wanted directories expl 'current directory from other shell' \
      compadd -Q -M "r:|/=* r:|=*" -f -a dirs
}

zle -C term_list menu-complete _generic
bindkey "^v" term_list
zstyle ':completion:term_list::::' completer _term_list
