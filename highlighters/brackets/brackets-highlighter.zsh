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


# Define default styles.
: ${ZSH_HIGHLIGHT_STYLES[bracket-error]:=fg=red,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-1]:=fg=blue,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-2]:=fg=green,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-3]:=fg=magenta,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-4]:=fg=yellow,bold}
: ${ZSH_HIGHLIGHT_STYLES[bracket-level-5]:=fg=cyan,bold}

# Whether the brackets highlighter should be called or not.
_zsh_highlight_brackets_highlighter_predicate()
{
  _zsh_highlight_cursor_moved || _zsh_highlight_buffer_modified
}

# Brackets highlighting function.
_zsh_highlight_brackets_highlighter()
{
  local level pos
  local -A levelpos lastoflevel matching typepos
  ((level = 0))
  for ((pos = 1; $pos <= ${#BUFFER}; pos++ )) ; do
    case $BUFFER[pos] in
      ["([{"])
        levelpos[$pos]=$((++level))
        lastoflevel[$level]=$pos
        typepos[$pos]=`_zsh_highlight_brackets_highlighter_brackettype $BUFFER[$pos]`
        ;;
      [")]}"])
        matching[$lastoflevel[$level]]=$pos
        matching[$pos]=$lastoflevel[$level]
        levelpos[$pos]=$((level--))
        typepos[$pos]=`_zsh_highlight_brackets_highlighter_brackettype $BUFFER[$pos]`
        ;;
      ['"'\'])
        local quotetype=$BUFFER[$pos]
        while (( $pos < ${#BUFFER} )) ; do
          ((++pos))
          [[ $BUFFER[$pos] == $quotetype ]] && break
        done
        ;;
    esac
  done
  for pos in ${(k)levelpos}; do
    if [[ -z $matching[$pos] ]] || [[ $typepos[$pos] != $typepos[$matching[$pos]] ]]; then
      region_highlight+=("$((pos - 1)) $pos "$ZSH_HIGHLIGHT_STYLES[bracket-error])
    else
      local bracket_color_size=${#ZSH_HIGHLIGHT_STYLES[(I)bracket-level-*]}
      local style=bracket-level-$(( (levelpos[$pos] - 1) % bracket_color_size + 1 ))
      region_highlight+=("$((pos - 1)) $pos "$ZSH_HIGHLIGHT_STYLES[$style])
    fi
  done
  ((pos = CURSOR + 1))
  if [[ -n $levelpos[$pos] ]] && [[ -n $matching[$pos] ]]; then
    local otherpos=$matching[$pos]
    region_highlight+=("$((otherpos - 1)) $otherpos standout")
  fi
}

_zsh_highlight_brackets_highlighter_brackettype()
{
  case $1 in
    ["()"]) print round;;
    ["[]"]) print bracket;;
    ["{}"]) print curly;;
    *) ;;
  esac
}
