#!/usr/bin/env zsh
# -------------------------------------------------------------------------------------------------
# Copyright (c) 2010-2011 zsh-syntax-highlighting contributors
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are permitted
# provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice, this list of conditions
#    and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright notice, this list of
#    conditions and the following disclaimer in the documentation and/or other materials provided
#    with the distribution.
#  * Neither the name of the zsh-syntax-highlighting contributors nor the names of its contributors
#    may be used to endorse or promote products derived from this software without specific prior
#    written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# -------------------------------------------------------------------------------------------------
# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
# -------------------------------------------------------------------------------------------------


ZSH_HIGHLIGHT_STYLES+=(
  bracket-error                 'fg=red,bold'
)

# Colors for bracket levels.
# Put as many color as you wish.
# Leave it as an empty array to disable.
ZSH_HIGHLIGHT_MATCHING_BRACKETS_STYLES=(
  'fg=blue,bold'
  'fg=green,bold'
  'fg=magenta,bold'
  'fg=yellow,bold'
  'fg=cyan,bold'
)

# Whether the bracket match highlighting shound be called or not.
_zsh_highlight_bracket-match-p() {
  _zsh_highlight_cursor-moved-p || _zsh_highlight_buffer-modified-p
}

# Bracket match highlighting.
_zsh_highlight_bracket-match() {
  bracket_color_size=${#ZSH_HIGHLIGHT_MATCHING_BRACKETS_STYLES}
  if ((bracket_color_size > 0)); then
    typeset -A levelpos lastoflevel matching revmatching
    ((level = 0))
    for pos in {1..${#BUFFER}}; do
      case $BUFFER[pos] in
        "("|"["|"{")
          levelpos[$pos]=$((++level))
          lastoflevel[$level]=$pos
          ;;
        ")"|"]"|"}")
          matching[$lastoflevel[$level]]=$pos
          revmatching[$pos]=$lastoflevel[$level]
          levelpos[$pos]=$((level--))
          ;;
      esac
    done
    for pos in ${(k)levelpos}; do
      level=$levelpos[$pos]
      if ((level < 1)); then
        region_highlight+=("$((pos - 1)) $pos "$ZSH_HIGHLIGHT_STYLES[bracket-error])
      else
        region_highlight+=("$((pos - 1)) $pos "$ZSH_HIGHLIGHT_MATCHING_BRACKETS_STYLES[(( (level - 1) % bracket_color_size + 1 ))])
      fi
    done
    ((c = CURSOR + 1))
    if [[ -n $levelpos[$c] ]]; then
      ((otherpos = -1))
      [[ -n $matching[$c] ]] && otherpos=$matching[$c]
      [[ -n $revmatching[$c] ]] && otherpos=$revmatching[$c]
      region_highlight+=("$((otherpos - 1)) $otherpos standout")
    fi
  fi
}

_zsh_highlight_add-highlighter _zsh_highlight_bracket-match
