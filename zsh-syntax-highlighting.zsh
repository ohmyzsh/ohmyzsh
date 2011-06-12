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


# -------------------------------------------------------------------------------------------------
# Core highlighting update system
# -------------------------------------------------------------------------------------------------

# Array declaring active highlighters names.
typeset -ga ZSH_HIGHLIGHT_HIGHLIGHTERS

# Update ZLE buffer syntax highlighting.
#
# Invokes each highlighter that needs updating.
# This function is supposed to be called whenever the ZLE state changes.
_zsh_highlight()
{
  setopt localoptions nowarncreateglobal

  # Store the previous command return code to restore it whatever happens.
  local ret=$?

  # Do not highlight if there are pending inputs (copy/paste).
  [[ $PENDING -gt 0 ]] && return $ret

  {
    local -a selected_highlighters
    local cache_place

    # Select which highlighters in ZSH_HIGHLIGHT_HIGHLIGHTERS need to be invoked.
    local highlighter; for highlighter in $ZSH_HIGHLIGHT_HIGHLIGHTERS; do

      # If highlighter needs to be invoked
      if "_zsh_highlight_${highlighter}_highlighter_predicate"; then

        # Mark the highlighter as selected for update.
        selected_highlighters+=($highlighter)

        # Remove what was stored in its cache from region_highlight.
        cache_place="_zsh_highlight_${highlighter}_highlighter_cache"
        [[ ${#${(P)cache_place}} -gt 0 ]] && region_highlight=(${region_highlight:#(${(P~j.|.)cache_place})})

      fi
    done

    # Invoke each selected highlighter and store the result in its cache.
    local -a region_highlight_copy
    for highlighter in $selected_highlighters; do
      cache_place="_zsh_highlight_${highlighter}_highlighter_cache"
      region_highlight_copy=($region_highlight)
      {
        "_zsh_highlight_${highlighter}_highlighter"
      } always  {
        : ${(PA)cache_place::=${region_highlight:#(${(~j.|.)region_highlight_copy})}}
      }
    done

  } always {
    _ZSH_HIGHLIGHT_PRIOR_BUFFER=$BUFFER
    _ZSH_HIGHLIGHT_PRIOR_CURSOR=$CURSOR
    return $ret
  }
}


# -------------------------------------------------------------------------------------------------
# API/utility functions for highlighters
# -------------------------------------------------------------------------------------------------

# Array used by highlighters to declare user overridable styles.
typeset -gA ZSH_HIGHLIGHT_STYLES

# Whether the command line buffer has been modified or not.
#
# Returns 0 if the buffer has changed since _zsh_highlight was last called.
_zsh_highlight_buffer_modified()
{
  [[ ${_ZSH_HIGHLIGHT_PRIOR_BUFFER:-} != $BUFFER ]]
}

# Whether the cursor has moved or not.
#
# Returns 0 if the cursor has moved since _zsh_highlight was last called.
_zsh_highlight_cursor_moved()
{
  ((_ZSH_HIGHLIGHT_PRIOR_CURSOR != $CURSOR))
}


# -------------------------------------------------------------------------------------------------
# Setup
# -------------------------------------------------------------------------------------------------

# Load ZSH module zsh/zleparameter, needed to override user defined widgets.
zmodload zsh/zleparameter 2>/dev/null || {
  echo 'zsh-syntax-highlighting: failed loading zsh/zleparameter, exiting.' >&2
  return -1
}

# Resolve highlighters directory location.
highlighters_dir="${ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR:-${${(%):-%N}:A:h}/highlighters}"
[[ -d $highlighters_dir ]] || {
  echo "zsh-syntax-highlighting: highlighters directory '$highlighters_dir' not found, exiting." >&2
  return -1
}

# Override ZLE widgets to make them invoke _zsh_highlight.
for event in ${${(f)"$(zle -la)"}:#(_*|orig-*|.run-help|.which-command)}; do
  if [[ "$widgets[$event]" == completion:* ]]; then
    eval "zle -C orig-$event ${${${widgets[$event]}#*:}/:/ } ; $event() { builtin zle orig-$event && _zsh_highlight } ; zle -N $event"
  else
    case $event in
      accept-and-menu-complete)
        eval "$event() { builtin zle .$event && _zsh_highlight } ; zle -N $event"
        ;;
      .*)
        clean_event=$event[2,${#event}] # Remove the leading dot in the event name
        case ${widgets[$clean_event]-} in
          (completion|user):*)
            ;;
          *)
            eval "$clean_event() { builtin zle $event && _zsh_highlight } ; zle -N $clean_event"
            ;;
        esac
        ;;
      *)
        ;;
    esac
  fi
done
unset event clean_event

# Load highlighters from highlighters directory and check they define required functions.
for highlighter_dir ($highlighters_dir/*/); do
  highlighter="${highlighter_dir:t}"
  [[ -f "$highlighter_dir/${highlighter}-highlighter.zsh" ]] && {
    . "$highlighter_dir/${highlighter}-highlighter.zsh"
    type "_zsh_highlight_${highlighter}_highlighter" &> /dev/null &&
    type "_zsh_highlight_${highlighter}_highlighter_predicate" &> /dev/null || {
      echo "zsh-syntax-highlighting: '${highlighter}' highlighter should define both required functions '_zsh_highlight_${highlighter}_highlighter' and '_zsh_highlight_${highlighter}_highlighter_predicate' in '${highlighter_dir}/${highlighter}-highlighter.zsh'." >&2
    }
  }
done
unset highlighter highlighter_dir highlighters_dir

# Initialize the array of active highlighters if needed.
[[ $#ZSH_HIGHLIGHT_HIGHLIGHTERS -eq 0 ]] && ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)
