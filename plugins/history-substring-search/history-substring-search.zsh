#!/usr/bin/env zsh
<<<<<<< HEAD
#
# This is a clean-room implementation of the Fish[1] shell's history search
# feature, where you can type in any part of any previously entered command
# and press the UP and DOWN arrow keys to cycle through the matching commands.
#
#-----------------------------------------------------------------------------
# Usage
#-----------------------------------------------------------------------------
#
# 1. Load this script into your interactive ZSH session:
#
#       % source history-substring-search.zsh
#
#    If you want to use the zsh-syntax-highlighting[6] script along with this
#    script, then make sure that you load it *before* you load this script:
#
#       % source zsh-syntax-highlighting.zsh
#       % source history-substring-search.zsh
#
# 2. Type any part of any previous command and then:
#
#     * Press the UP arrow key to select the nearest command that (1) contains
#       your query and (2) is older than the current command in the command
#       history.
#
#     * Press the DOWN arrow key to select the nearest command that (1)
#       contains your query and (2) is newer than the current command in the
#       command history.
#
#     * Press ^U (the Control and U keys simultaneously) to abort the search.
#
# 3. If a matching command spans more than one line of text, press the LEFT
#    arrow key to move the cursor away from the end of the command, and then:
#
#     * Press the UP arrow key to move the cursor to the line above.  When the
#       cursor reaches the first line of the command, pressing the UP arrow
#       key again will cause this script to perform another search.
#
#     * Press the DOWN arrow key to move the cursor to the line below.  When
#       the cursor reaches the last line of the command, pressing the DOWN
#       arrow key again will cause this script to perform another search.
#
#-----------------------------------------------------------------------------
# Configuration
#-----------------------------------------------------------------------------
#
# This script defines the following global variables. You may override their
# default values only after having loaded this script into your ZSH session.
#
# * HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND is a global variable that defines
#   how the query should be highlighted inside a matching command. Its default
#   value causes this script to highlight using bold, white text on a magenta
#   background. See the "Character Highlighting" section in the zshzle(1) man
#   page to learn about the kinds of values you may assign to this variable.
#
# * HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND is a global variable that
#   defines how the query should be highlighted when no commands in the
#   history match it. Its default value causes this script to highlight using
#   bold, white text on a red background. See the "Character Highlighting"
#   section in the zshzle(1) man page to learn about the kinds of values you
#   may assign to this variable.
#
# * HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS is a global variable that defines
#   how the command history will be searched for your query. Its default value
#   causes this script to perform a case-insensitive search. See the "Globbing
#   Flags" section in the zshexpn(1) man page to learn about the kinds of
#   values you may assign to this variable.
#
#-----------------------------------------------------------------------------
# History
#-----------------------------------------------------------------------------
#
# This script was originally written by Peter Stephenson[2], who published it
# to the ZSH users mailing list (thereby making it public domain) in September
# 2009. It was later revised by Guido van Steen and released under the BSD
# license (see below) as part of the fizsh[3] project in January 2011.
#
# It was later extracted from fizsh[3] release 1.0.1, refactored heavily, and
# repackaged as both an oh-my-zsh plugin[4] and as an independently loadable
# ZSH script[5] by Suraj N. Kurapati in 2011.
#
# It was further developed[4] by Guido van Steen, Suraj N. Kurapati, Sorin
# Ionescu, and Vincent Guerci in 2011.
#
# [1]: http://fishshell.com
# [2]: http://www.zsh.org/mla/users/2009/msg00818.html
# [3]: http://sourceforge.net/projects/fizsh/
# [4]: https://github.com/robbyrussell/oh-my-zsh/pull/215
# [5]: https://github.com/sunaku/zsh-history-substring-search
# [6]: https://github.com/nicoulaj/zsh-syntax-highlighting
#
=======
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
##############################################################################
#
# Copyright (c) 2009 Peter Stephenson
# Copyright (c) 2011 Guido van Steen
# Copyright (c) 2011 Suraj N. Kurapati
# Copyright (c) 2011 Sorin Ionescu
# Copyright (c) 2011 Vincent Guerci
<<<<<<< HEAD
=======
# Copyright (c) 2016 Geza Lore
# Copyright (c) 2017 Bengt Brodersen
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  * Redistributions in binary form must reproduce the above
#    copyright notice, this list of conditions and the following
#    disclaimer in the documentation and/or other materials provided
#    with the distribution.
#
#  * Neither the name of the FIZSH nor the names of its contributors
#    may be used to endorse or promote products derived from this
#    software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
##############################################################################

#-----------------------------------------------------------------------------
<<<<<<< HEAD
# configuration variables
#-----------------------------------------------------------------------------

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'
=======
# declare global configuration variables
#-----------------------------------------------------------------------------

typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=white,bold'
typeset -g HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
typeset -g HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'
typeset -g HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=''
typeset -g HISTORY_SUBSTRING_SEARCH_FUZZY=''

#-----------------------------------------------------------------------------
# declare internal global variables
#-----------------------------------------------------------------------------

typeset -g BUFFER MATCH MBEGIN MEND CURSOR
typeset -g _history_substring_search_refresh_display
typeset -g _history_substring_search_query_highlight
typeset -g _history_substring_search_result
typeset -g _history_substring_search_query
typeset -g -a _history_substring_search_query_parts
typeset -g -a _history_substring_search_raw_matches
typeset -g -i _history_substring_search_raw_match_index
typeset -g -a _history_substring_search_matches
typeset -g -i _history_substring_search_match_index
typeset -g -A _history_substring_search_unique_filter
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

#-----------------------------------------------------------------------------
# the main ZLE widgets
#-----------------------------------------------------------------------------

<<<<<<< HEAD
function history-substring-search-up() {
=======
history-substring-search-up() {
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  _history-substring-search-begin

  _history-substring-search-up-history ||
  _history-substring-search-up-buffer ||
  _history-substring-search-up-search

  _history-substring-search-end
}

<<<<<<< HEAD
function history-substring-search-down() {
=======
history-substring-search-down() {
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  _history-substring-search-begin

  _history-substring-search-down-history ||
  _history-substring-search-down-buffer ||
  _history-substring-search-down-search

  _history-substring-search-end
}

zle -N history-substring-search-up
zle -N history-substring-search-down

<<<<<<< HEAD
zmodload zsh/terminfo
if [[ -n "$terminfo[kcuu1]" ]]; then
  bindkey "$terminfo[kcuu1]" history-substring-search-up
fi
if [[ -n "$terminfo[kcud1]" ]]; then
  bindkey "$terminfo[kcud1]" history-substring-search-down
fi

=======
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
#-----------------------------------------------------------------------------
# implementation details
#-----------------------------------------------------------------------------

zmodload -F zsh/parameter

#
# We have to "override" some keys and widgets if the
# zsh-syntax-highlighting plugin has not been loaded:
#
# https://github.com/nicoulaj/zsh-syntax-highlighting
#
if [[ $+functions[_zsh_highlight] -eq 0 ]]; then
  #
<<<<<<< HEAD
  # Dummy implementation of _zsh_highlight()
  # that simply removes existing highlights
  #
  function _zsh_highlight() {
    region_highlight=()
  }

  #
  # Remove existing highlights when the user
  # inserts printable characters into $BUFFER
  #
  function ordinary-key-press() {
    if [[ $KEYS == [[:print:]] ]]; then
      region_highlight=()
    fi
    zle .self-insert
  }
  zle -N self-insert ordinary-key-press

  #
  # Override ZLE widgets to invoke _zsh_highlight()
  #
  # https://github.com/nicoulaj/zsh-syntax-highlighting/blob/
  # bb7fcb79fad797a40077bebaf6f4e4a93c9d8163/zsh-syntax-highlighting.zsh#L121
  #
  #--------------8<-------------------8<-------------------8<-----------------
=======
  # Dummy implementation of _zsh_highlight() that
  # simply removes any existing highlights when the
  # user inserts printable characters into $BUFFER.
  #
  _zsh_highlight() {
    if [[ $KEYS == [[:print:]] ]]; then
      region_highlight=()
    fi
  }

  #
  # The following snippet was taken from the zsh-syntax-highlighting project:
  #
  # https://github.com/zsh-users/zsh-syntax-highlighting/blob/56b134f5d62ae3d4e66c7f52bd0cc2595f9b305b/zsh-syntax-highlighting.zsh#L126-161
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  #
  # Copyright (c) 2010-2011 zsh-syntax-highlighting contributors
  # All rights reserved.
  #
  # Redistribution and use in source and binary forms, with or without
  # modification, are permitted provided that the following conditions are
  # met:
  #
  #  * Redistributions of source code must retain the above copyright
  #    notice, this list of conditions and the following disclaimer.
  #
  #  * Redistributions in binary form must reproduce the above copyright
  #    notice, this list of conditions and the following disclaimer in the
  #    documentation and/or other materials provided with the distribution.
  #
  #  * Neither the name of the zsh-syntax-highlighting contributors nor the
  #    names of its contributors may be used to endorse or promote products
  #    derived from this software without specific prior written permission.
  #
  # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  # IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  # THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  # PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
  # CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  # EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  # PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  # PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  # LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  # NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  # SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
<<<<<<< HEAD

  # Load ZSH module zsh/zleparameter, needed to override user defined widgets.
  zmodload zsh/zleparameter 2>/dev/null || {
    echo 'zsh-syntax-highlighting: failed loading zsh/zleparameter, exiting.' >&2
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

        # The following widgets should NOT remove any previously
        # applied highlighting. Therefore we do not remap them.
        .forward-char|.backward-char|.up-line-or-history|.down-line-or-history)
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
  #-------------->8------------------->8------------------->8-----------------
fi

function _history-substring-search-begin() {
  setopt localoptions extendedglob
  _history_substring_search_move_cursor_eol=false
  _history_substring_search_query_highlight=

  #
  # Continue using the previous $_history_substring_search_result by default,
  # unless the current query was cleared or a new/different query was entered.
  #
  if [[ -z $BUFFER || $BUFFER != $_history_substring_search_result ]]; then
    #
    # For the purpose of highlighting we will also keep
    # a version without doubly-escaped meta characters.
    #
    _history_substring_search_query=$BUFFER

    #
    # $BUFFER contains the text that is in the command-line currently.
    # we put an extra "\\" before meta characters such as "\(" and "\)",
    # so that they become "\\\(" and "\\\)".
    #
    _history_substring_search_query_escaped=${BUFFER//(#m)[\][()|\\*?#<>~^]/\\$MATCH}

    #
    # Find all occurrences of the search query in the history file.
    #
    # (k) turns it an array of line numbers.
    #
    # (on) seems to remove duplicates, which are default
    #      options. They can be turned off by (ON).
    #
    _history_substring_search_matches=(${(kon)history[(R)(#$HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS)*${_history_substring_search_query_escaped}*]})

    #
    # Define the range of values that $_history_substring_search_match_index
    # can take: [0, $_history_substring_search_matches_count_plus].
    #
    _history_substring_search_matches_count=$#_history_substring_search_matches
    _history_substring_search_matches_count_plus=$(( _history_substring_search_matches_count + 1 ))
    _history_substring_search_matches_count_sans=$(( _history_substring_search_matches_count - 1 ))

    #
    # If $_history_substring_search_match_index is equal to
    # $_history_substring_search_matches_count_plus, this indicates that we
    # are beyond the beginning of $_history_substring_search_matches.
    #
    # If $_history_substring_search_match_index is equal to 0, this indicates
    # that we are beyond the end of $_history_substring_search_matches.
    #
    # If we have initially pressed "up" we have to initialize
    # $_history_substring_search_match_index to
    # $_history_substring_search_matches_count_plus so that it will be
    # decreased to $_history_substring_search_matches_count.
    #
    # If we have initially pressed "down" we have to initialize
    # $_history_substring_search_match_index to
    # $_history_substring_search_matches_count so that it will be increased to
    # $_history_substring_search_matches_count_plus.
    #
    if [[ $WIDGET == history-substring-search-down ]]; then
       _history_substring_search_match_index=$_history_substring_search_matches_count
    else
      _history_substring_search_match_index=$_history_substring_search_matches_count_plus
    fi
  fi
}

function _history-substring-search-end() {
  setopt localoptions extendedglob
  _history_substring_search_result=$BUFFER

  # move the cursor to the end of the command line
  if [[ $_history_substring_search_move_cursor_eol == true ]]; then
=======
  #
  #--------------8<-------------------8<-------------------8<-----------------
  # Rebind all ZLE widgets to make them invoke _zsh_highlights.
  _zsh_highlight_bind_widgets()
  {
    # Load ZSH module zsh/zleparameter, needed to override user defined widgets.
    zmodload zsh/zleparameter 2>/dev/null || {
      echo 'zsh-syntax-highlighting: failed loading zsh/zleparameter.' >&2
      return 1
    }

    # Override ZLE widgets to make them invoke _zsh_highlight.
    local cur_widget
    for cur_widget in ${${(f)"$(builtin zle -la)"}:#(.*|_*|orig-*|run-help|which-command|beep|yank*)}; do
      case $widgets[$cur_widget] in

        # Already rebound event: do nothing.
        user:$cur_widget|user:_zsh_highlight_widget_*);;

        # User defined widget: override and rebind old one with prefix "orig-".
        user:*) eval "zle -N orig-$cur_widget ${widgets[$cur_widget]#*:}; \
                      _zsh_highlight_widget_$cur_widget() { builtin zle orig-$cur_widget -- \"\$@\" && _zsh_highlight }; \
                      zle -N $cur_widget _zsh_highlight_widget_$cur_widget";;

        # Completion widget: override and rebind old one with prefix "orig-".
        completion:*) eval "zle -C orig-$cur_widget ${${widgets[$cur_widget]#*:}/:/ }; \
                            _zsh_highlight_widget_$cur_widget() { builtin zle orig-$cur_widget -- \"\$@\" && _zsh_highlight }; \
                            zle -N $cur_widget _zsh_highlight_widget_$cur_widget";;

        # Builtin widget: override and make it call the builtin ".widget".
        builtin) eval "_zsh_highlight_widget_$cur_widget() { builtin zle .$cur_widget -- \"\$@\" && _zsh_highlight }; \
                       zle -N $cur_widget _zsh_highlight_widget_$cur_widget";;

        # Default: unhandled case.
        *) echo "zsh-syntax-highlighting: unhandled ZLE widget '$cur_widget'" >&2 ;;
      esac
    done
  }
  #-------------->8------------------->8------------------->8-----------------

  _zsh_highlight_bind_widgets
fi

_history-substring-search-begin() {
  setopt localoptions extendedglob

  _history_substring_search_refresh_display=
  _history_substring_search_query_highlight=

  #
  # If the buffer is the same as the previously displayed history substring
  # search result, then just keep stepping through the match list. Otherwise
  # start a new search.
  #
  if [[ -n $BUFFER && $BUFFER == ${_history_substring_search_result:-} ]]; then
    return;
  fi

  #
  # Clear the previous result.
  #
  _history_substring_search_result=''

  if [[ -z $BUFFER ]]; then
    #
    # If the buffer is empty, we will just act like up-history/down-history
    # in ZSH, so we do not need to actually search the history. This should
    # speed things up a little.
    #
    _history_substring_search_query=
    _history_substring_search_query_parts=()
    _history_substring_search_raw_matches=()

  else
    #
    # For the purpose of highlighting we keep a copy of the original
    # query string.
    #
    _history_substring_search_query=$BUFFER

    #
    # compose search pattern
    #
    if [[ -n $HISTORY_SUBSTRING_SEARCH_FUZZY ]]; then
      #
      # `=` split string in arguments
      #
      _history_substring_search_query_parts=(${=_history_substring_search_query})
    else
      _history_substring_search_query_parts=(${==_history_substring_search_query})
    fi

    #
    # Escape and join query parts with wildcard character '*' as separator
    # `(j:CHAR:)` join array to string with CHAR as separator
    #
    local search_pattern="*${(j:*:)_history_substring_search_query_parts[@]//(#m)[\][()|\\*?#<>~^]/\\$MATCH}*"

    #
    # Find all occurrences of the search pattern in the history file.
    #
    # (k) returns the "keys" (history index numbers) instead of the values
    # (R) returns values in reverse older, so the index of the youngest
    # matching history entry is at the head of the list.
    #
    _history_substring_search_raw_matches=(${(k)history[(R)(#$HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS)${search_pattern}]})
  fi

  #
  # In order to stay as responsive as possible, we will process the raw
  # matches lazily (when the user requests the next match) to choose items
  # that need to be displayed to the user.
  # _history_substring_search_raw_match_index holds the index of the last
  # unprocessed entry in _history_substring_search_raw_matches. Any items
  # that need to be displayed will be added to
  # _history_substring_search_matches.
  #
  # We use an associative array (_history_substring_search_unique_filter) as
  # a 'set' data structure to ensure uniqueness of the results if desired.
  # If an entry (key) is in the set (non-empty value), then we have already
  # added that entry to _history_substring_search_matches.
  #
  _history_substring_search_raw_match_index=0
  _history_substring_search_matches=()
  _history_substring_search_unique_filter=()

  #
  # If $_history_substring_search_match_index is equal to
  # $#_history_substring_search_matches + 1, this indicates that we
  # are beyond the end of $_history_substring_search_matches and that we
  # have also processed all entries in
  # _history_substring_search_raw_matches.
  #
  # If $#_history_substring_search_match_index is equal to 0, this indicates
  # that we are beyond the beginning of $_history_substring_search_matches.
  #
  # If we have initially pressed "up" we have to initialize
  # $_history_substring_search_match_index to 0 so that it will be
  # incremented to 1.
  #
  # If we have initially pressed "down" we have to initialize
  # $_history_substring_search_match_index to 1 so that it will be
  # decremented to 0.
  #
  if [[ $WIDGET == history-substring-search-down ]]; then
     _history_substring_search_match_index=1
  else
    _history_substring_search_match_index=0
  fi
}

_history-substring-search-end() {
  setopt localoptions extendedglob

  _history_substring_search_result=$BUFFER

  # the search was successful so display the result properly by clearing away
  # existing highlights and moving the cursor to the end of the result buffer
  if [[ $_history_substring_search_refresh_display -eq 1 ]]; then
    region_highlight=()
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
    CURSOR=${#BUFFER}
  fi

  # highlight command line using zsh-syntax-highlighting
  _zsh_highlight

  # highlight the search query inside the command line
<<<<<<< HEAD
  if [[ -n $_history_substring_search_query_highlight && -n $_history_substring_search_query ]]; then
    #
    # The following expression yields a variable $MBEGIN, which
    # indicates the begin position + 1 of the first occurrence
    # of _history_substring_search_query_escaped in $BUFFER.
    #
    : ${(S)BUFFER##(#m$HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS)($_history_substring_search_query##)}
    local begin=$(( MBEGIN - 1 ))
    local end=$(( begin + $#_history_substring_search_query ))
    region_highlight+=("$begin $end $_history_substring_search_query_highlight")
=======
  if [[ -n $_history_substring_search_query_highlight ]]; then
    # highlight first matching query parts
    local highlight_start_index=0
    local highlight_end_index=0
    local query_part
    for query_part in $_history_substring_search_query_parts; do
      local escaped_query_part=${query_part//(#m)[\][()|\\*?#<>~^]/\\$MATCH}
      # (i) get index of pattern
      local query_part_match_index="${${BUFFER:$highlight_start_index}[(i)(#$HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS)${escaped_query_part}]}"
      if [[ $query_part_match_index -le ${#BUFFER:$highlight_start_index} ]]; then
        highlight_start_index=$(( $highlight_start_index + $query_part_match_index ))
        highlight_end_index=$(( $highlight_start_index + ${#query_part} ))
        region_highlight+=("$(($highlight_start_index - 1)) $(($highlight_end_index - 1)) $_history_substring_search_query_highlight")
      fi
    done
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  fi

  # For debugging purposes:
  # zle -R "mn: "$_history_substring_search_match_index" m#: "${#_history_substring_search_matches}
  # read -k -t 200 && zle -U $REPLY

  # Exit successfully from the history-substring-search-* widgets.
<<<<<<< HEAD
  true
}

function _history-substring-search-up-buffer() {
=======
  return 0
}

_history-substring-search-up-buffer() {
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  #
  # Check if the UP arrow was pressed to move the cursor within a multi-line
  # buffer. This amounts to three tests:
  #
  # 1. $#buflines -gt 1.
  #
  # 2. $CURSOR -ne $#BUFFER.
  #
  # 3. Check if we are on the first line of the current multi-line buffer.
  #    If so, pressing UP would amount to leaving the multi-line buffer.
  #
  #    We check this by adding an extra "x" to $LBUFFER, which makes
  #    sure that xlbuflines is always equal to the number of lines
  #    until $CURSOR (including the line with the cursor on it).
  #
  local buflines XLBUFFER xlbuflines
  buflines=(${(f)BUFFER})
  XLBUFFER=$LBUFFER"x"
  xlbuflines=(${(f)XLBUFFER})

  if [[ $#buflines -gt 1 && $CURSOR -ne $#BUFFER && $#xlbuflines -ne 1 ]]; then
    zle up-line-or-history
<<<<<<< HEAD
    return true
  fi

  false
}

function _history-substring-search-down-buffer() {
=======
    return 0
  fi

  return 1
}

_history-substring-search-down-buffer() {
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  #
  # Check if the DOWN arrow was pressed to move the cursor within a multi-line
  # buffer. This amounts to three tests:
  #
  # 1. $#buflines -gt 1.
  #
  # 2. $CURSOR -ne $#BUFFER.
  #
  # 3. Check if we are on the last line of the current multi-line buffer.
  #    If so, pressing DOWN would amount to leaving the multi-line buffer.
  #
  #    We check this by adding an extra "x" to $RBUFFER, which makes
  #    sure that xrbuflines is always equal to the number of lines
  #    from $CURSOR (including the line with the cursor on it).
  #
  local buflines XRBUFFER xrbuflines
  buflines=(${(f)BUFFER})
  XRBUFFER="x"$RBUFFER
  xrbuflines=(${(f)XRBUFFER})

  if [[ $#buflines -gt 1 && $CURSOR -ne $#BUFFER && $#xrbuflines -ne 1 ]]; then
    zle down-line-or-history
<<<<<<< HEAD
    return true
  fi

  false
}

function _history-substring-search-up-history() {
=======
    return 0
  fi

  return 1
}

_history-substring-search-up-history() {
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  #
  # Behave like up in ZSH, except clear the $BUFFER
  # when beginning of history is reached like in Fish.
  #
  if [[ -z $_history_substring_search_query ]]; then

    # we have reached the absolute top of history
    if [[ $HISTNO -eq 1 ]]; then
      BUFFER=

    # going up from somewhere below the top of history
    else
<<<<<<< HEAD
      zle up-history
    fi

    return true
  fi

  false
}

function _history-substring-search-down-history() {
=======
      zle up-line-or-history
    fi

    return 0
  fi

  return 1
}

_history-substring-search-down-history() {
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  #
  # Behave like down-history in ZSH, except clear the
  # $BUFFER when end of history is reached like in Fish.
  #
  if [[ -z $_history_substring_search_query ]]; then

    # going down from the absolute top of history
    if [[ $HISTNO -eq 1 && -z $BUFFER ]]; then
      BUFFER=${history[1]}
<<<<<<< HEAD
      _history_substring_search_move_cursor_eol=true

    # going down from somewhere above the bottom of history
    else
      zle down-history
    fi

    return true
  fi

  false
}

function _history-substring-search-up-search() {
  _history_substring_search_move_cursor_eol=true

  #
  # Highlight matches during history-substring-up-search:
  #
  # The following constants have been initialized in
  # _history-substring-search-up/down-search():
  #
  # $_history_substring_search_matches is the current list of matches
  # $_history_substring_search_matches_count is the current number of matches
  # $_history_substring_search_matches_count_plus is the current number of matches + 1
  # $_history_substring_search_matches_count_sans is the current number of matches - 1
  # $_history_substring_search_match_index is the index of the current match
  #
  # The range of values that $_history_substring_search_match_index can take
  # is: [0, $_history_substring_search_matches_count_plus].  A value of 0
  # indicates that we are beyond the end of
  # $_history_substring_search_matches. A value of
  # $_history_substring_search_matches_count_plus indicates that we are beyond
  # the beginning of $_history_substring_search_matches.
  #
  # In _history-substring-search-up-search() the initial value of
  # $_history_substring_search_match_index is
  # $_history_substring_search_matches_count_plus.  This value is set in
  # _history-substring-search-begin().  _history-substring-search-up-search()
  # will initially decrease it to $_history_substring_search_matches_count.
  #
  if [[ $_history_substring_search_match_index -ge 2 ]]; then
    #
    # Highlight the next match:
    #
    # 1. Decrease the value of $_history_substring_search_match_index.
    #
    # 2. Use $HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND
    #    to highlight the current buffer.
    #
    (( _history_substring_search_match_index-- ))
    BUFFER=$history[$_history_substring_search_matches[$_history_substring_search_match_index]]
    _history_substring_search_query_highlight=$HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND

  elif [[ $_history_substring_search_match_index -eq 1 ]]; then
    #
    # We will move beyond the end of $_history_substring_search_matches:
    #
    # 1. Decrease the value of $_history_substring_search_match_index.
    #
    # 2. Save the current buffer in $_history_substring_search_old_buffer,
    #    so that it can be retrieved by
    #    _history-substring-search-down-search() later.
    #
    # 3. Make $BUFFER equal to $_history_substring_search_query.
    #
    # 4. Use $HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND
    #    to highlight the current buffer.
    #
    (( _history_substring_search_match_index-- ))
    _history_substring_search_old_buffer=$BUFFER
    BUFFER=$_history_substring_search_query
    _history_substring_search_query_highlight=$HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND

  elif [[ $_history_substring_search_match_index -eq $_history_substring_search_matches_count_plus ]]; then
    #
    # We were beyond the beginning of $_history_substring_search_matches but
    # UP makes us move back to $_history_substring_search_matches:
    #
    # 1. Decrease the value of $_history_substring_search_match_index.
    #
    # 2. Restore $BUFFER from $_history_substring_search_old_buffer.
    #
    # 3. Use $HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND
    #    to highlight the current buffer.
    #
    (( _history_substring_search_match_index-- ))
    BUFFER=$_history_substring_search_old_buffer
    _history_substring_search_query_highlight=$HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND
  fi
}

function _history-substring-search-down-search() {
  _history_substring_search_move_cursor_eol=true

  #
  # Highlight matches during history-substring-up-search:
  #
  # The following constants have been initialized in
  # _history-substring-search-up/down-search():
  #
  # $_history_substring_search_matches is the current list of matches
  # $_history_substring_search_matches_count is the current number of matches
  # $_history_substring_search_matches_count_plus is the current number of matches + 1
  # $_history_substring_search_matches_count_sans is the current number of matches - 1
  # $_history_substring_search_match_index is the index of the current match
  #
  # The range of values that $_history_substring_search_match_index can take
  # is: [0, $_history_substring_search_matches_count_plus].  A value of 0
  # indicates that we are beyond the end of
  # $_history_substring_search_matches. A value of
  # $_history_substring_search_matches_count_plus indicates that we are beyond
  # the beginning of $_history_substring_search_matches.
  #
  # In _history-substring-search-down-search() the initial value of
  # $_history_substring_search_match_index is
  # $_history_substring_search_matches_count.  This value is set in
  # _history-substring-search-begin().
  # _history-substring-search-down-search() will initially increase it to
  # $_history_substring_search_matches_count_plus.
  #
  if [[ $_history_substring_search_match_index -le $_history_substring_search_matches_count_sans ]]; then
    #
    # Highlight the next match:
    #
    # 1. Increase $_history_substring_search_match_index by 1.
    #
    # 2. Use $HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND
    #    to highlight the current buffer.
    #
    (( _history_substring_search_match_index++ ))
    BUFFER=$history[$_history_substring_search_matches[$_history_substring_search_match_index]]
    _history_substring_search_query_highlight=$HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND

  elif [[ $_history_substring_search_match_index -eq $_history_substring_search_matches_count ]]; then
    #
    # We will move beyond the beginning of $_history_substring_search_matches:
    #
    # 1. Increase $_history_substring_search_match_index by 1.
    #
    # 2. Save the current buffer in $_history_substring_search_old_buffer, so
    #    that it can be retrieved by _history-substring-search-up-search()
    #    later.
    #
    # 3. Make $BUFFER equal to $_history_substring_search_query.
    #
    # 4. Use $HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND
    #    to highlight the current buffer.
    #
    (( _history_substring_search_match_index++ ))
    _history_substring_search_old_buffer=$BUFFER
    BUFFER=$_history_substring_search_query
    _history_substring_search_query_highlight=$HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND

  elif [[ $_history_substring_search_match_index -eq 0 ]]; then
    #
    # We were beyond the end of $_history_substring_search_matches but DOWN
    # makes us move back to the $_history_substring_search_matches:
    #
    # 1. Increase $_history_substring_search_match_index by 1.
    #
    # 2. Restore $BUFFER from $_history_substring_search_old_buffer.
    #
    # 3. Use $HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND
    #    to highlight the current buffer.
    #
    (( _history_substring_search_match_index++ ))
    BUFFER=$_history_substring_search_old_buffer
    _history_substring_search_query_highlight=$HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND
=======
      _history_substring_search_refresh_display=1

    # going down from somewhere above the bottom of history
    else
      zle down-line-or-history
    fi

    return 0
  fi

  return 1
}

_history_substring_search_process_raw_matches() {
  #
  # Process more outstanding raw matches and append any matches that need to
  # be displayed to the user to _history_substring_search_matches.
  # Return whether there were any more results appended.
  #

  #
  # While we have more raw matches. Process them to see if there are any more
  # matches that need to be displayed to the user.
  #
  while [[ $_history_substring_search_raw_match_index -lt $#_history_substring_search_raw_matches ]]; do
    #
    # Move on to the next raw entry and get its history index.
    #
    _history_substring_search_raw_match_index+=1
    local index=${_history_substring_search_raw_matches[$_history_substring_search_raw_match_index]}

    #
    # If HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE is set to a non-empty value,
    # then ensure that only unique matches are presented to the user.
    # When HIST_IGNORE_ALL_DUPS is set, ZSH already ensures a unique history,
    # so in this case we do not need to do anything.
    #
    if [[ ! -o HIST_IGNORE_ALL_DUPS && -n $HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE ]]; then
      #
      # Get the actual history entry at the new index, and check if we have
      # already added it to _history_substring_search_matches.
      #
      local entry=${history[$index]}

      if [[ -z ${_history_substring_search_unique_filter[$entry]} ]]; then
        #
        # This is a new unique entry. Add it to the filter and append the
        # index to _history_substring_search_matches.
        #
        _history_substring_search_unique_filter[$entry]=1
        _history_substring_search_matches+=($index)

        #
        # Indicate that we did find a match.
        #
        return 0
      fi

    else
      #
      # Just append the new history index to the processed matches.
      #
      _history_substring_search_matches+=($index)

      #
      # Indicate that we did find a match.
      #
      return 0
    fi

  done

  #
  # We are beyond the end of the list of raw matches. Indicate that no
  # more matches are available.
  #
  return 1
}

_history-substring-search-has-next() {
  #
  # Predicate function that returns whether any more older matches are
  # available.
  #

  if  [[ $_history_substring_search_match_index -lt $#_history_substring_search_matches ]]; then
    #
    # We did not reach the end of the processed list, so we do have further
    # matches.
    #
    return 0

  else
    #
    # We are at the end of the processed list. Try to process further
    # unprocessed matches. _history_substring_search_process_raw_matches
    # returns whether any more matches were available, so just return
    # that result.
    #
    _history_substring_search_process_raw_matches
    return $?
  fi
}

_history-substring-search-has-prev() {
  #
  # Predicate function that returns whether any more younger matches are
  # available.
  #

  if [[ $_history_substring_search_match_index -gt 1 ]]; then
    #
    # We did not reach the beginning of the processed list, so we do have
    # further matches.
    #
    return 0

  else
    #
    # We are at the beginning of the processed list. We do not have any more
    # matches.
    #
    return 1
  fi
}

_history-substring-search-found() {
  #
  # A match is available. The index of the match is held in
  # $_history_substring_search_match_index
  #
  # 1. Make $BUFFER equal to the matching history entry.
  #
  # 2. Use $HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND
  #    to highlight the current buffer.
  #
  BUFFER=$history[$_history_substring_search_matches[$_history_substring_search_match_index]]
  _history_substring_search_query_highlight=$HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND
}

_history-substring-search-not-found() {
  #
  # No more matches are available.
  #
  # 1. Make $BUFFER equal to $_history_substring_search_query so the user can
  #    revise it and search again.
  #
  # 2. Use $HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND
  #    to highlight the current buffer.
  #
  BUFFER=$_history_substring_search_query
  _history_substring_search_query_highlight=$HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND
}

_history-substring-search-up-search() {
  _history_substring_search_refresh_display=1

  #
  # Select history entry during history-substring-down-search:
  #
  # The following variables have been initialized in
  # _history-substring-search-up/down-search():
  #
  # $_history_substring_search_matches is the current list of matches that
  # need to be displayed to the user.
  # $_history_substring_search_match_index is the index of the current match
  # that is being displayed to the user.
  #
  # The range of values that $_history_substring_search_match_index can take
  # is: [0, $#_history_substring_search_matches + 1].  A value of 0
  # indicates that we are beyond the beginning of
  # $_history_substring_search_matches. A value of
  # $#_history_substring_search_matches + 1 indicates that we are beyond
  # the end of $_history_substring_search_matches and that we have also
  # processed all entries in _history_substring_search_raw_matches.
  #
  # If $_history_substring_search_match_index equals
  # $#_history_substring_search_matches and
  # $_history_substring_search_raw_match_index is not greater than
  # $#_history_substring_search_raw_matches, then we need to further process
  # $_history_substring_search_raw_matches to see if there are any more
  # entries that need to be displayed to the user.
  #
  # In _history-substring-search-up-search() the initial value of
  # $_history_substring_search_match_index is 0. This value is set in
  # _history-substring-search-begin(). _history-substring-search-up-search()
  # will initially increment it to 1.
  #

  if [[ $_history_substring_search_match_index -gt $#_history_substring_search_matches ]]; then
    #
    # We are beyond the end of $_history_substring_search_matches. This
    # can only happen if we have also exhausted the unprocessed matches in
    # _history_substring_search_raw_matches.
    #
    # 1. Update display to indicate search not found.
    #
    _history-substring-search-not-found
    return
  fi

  if _history-substring-search-has-next; then
    #
    # We do have older matches.
    #
    # 1. Move index to point to the next match.
    # 2. Update display to indicate search found.
    #
    _history_substring_search_match_index+=1
    _history-substring-search-found

  else
    #
    # We do not have older matches.
    #
    # 1. Move the index beyond the end of
    #    _history_substring_search_matches.
    # 2. Update display to indicate search not found.
    #
    _history_substring_search_match_index+=1
    _history-substring-search-not-found
  fi

  #
  # When HIST_FIND_NO_DUPS is set, meaning that only unique command lines from
  # history should be matched, make sure the new and old results are different.
  #
  # However, if the HIST_IGNORE_ALL_DUPS shell option, or
  # HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE is set, then we already have a
  # unique history, so in this case we do not need to do anything.
  #
  if [[ -o HIST_IGNORE_ALL_DUPS || -n $HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE ]]; then
    return
  fi

  if [[ -o HIST_FIND_NO_DUPS && $BUFFER == $_history_substring_search_result ]]; then
    #
    # Repeat the current search so that a different (unique) match is found.
    #
    _history-substring-search-up-search
  fi
}

_history-substring-search-down-search() {
  _history_substring_search_refresh_display=1

  #
  # Select history entry during history-substring-down-search:
  #
  # The following variables have been initialized in
  # _history-substring-search-up/down-search():
  #
  # $_history_substring_search_matches is the current list of matches that
  # need to be displayed to the user.
  # $_history_substring_search_match_index is the index of the current match
  # that is being displayed to the user.
  #
  # The range of values that $_history_substring_search_match_index can take
  # is: [0, $#_history_substring_search_matches + 1].  A value of 0
  # indicates that we are beyond the beginning of
  # $_history_substring_search_matches. A value of
  # $#_history_substring_search_matches + 1 indicates that we are beyond
  # the end of $_history_substring_search_matches and that we have also
  # processed all entries in _history_substring_search_raw_matches.
  #
  # In _history-substring-search-down-search() the initial value of
  # $_history_substring_search_match_index is 1. This value is set in
  # _history-substring-search-begin(). _history-substring-search-down-search()
  # will initially decrement it to 0.
  #

  if [[ $_history_substring_search_match_index -lt 1 ]]; then
    #
    # We are beyond the beginning of $_history_substring_search_matches.
    #
    # 1. Update display to indicate search not found.
    #
    _history-substring-search-not-found
    return
  fi

  if _history-substring-search-has-prev; then
    #
    # We do have younger matches.
    #
    # 1. Move index to point to the previous match.
    # 2. Update display to indicate search found.
    #
    _history_substring_search_match_index+=-1
    _history-substring-search-found

  else
    #
    # We do not have younger matches.
    #
    # 1. Move the index beyond the beginning of
    #    _history_substring_search_matches.
    # 2. Update display to indicate search not found.
    #
    _history_substring_search_match_index+=-1
    _history-substring-search-not-found
  fi

  #
  # When HIST_FIND_NO_DUPS is set, meaning that only unique command lines from
  # history should be matched, make sure the new and old results are different.
  #
  # However, if the HIST_IGNORE_ALL_DUPS shell option, or
  # HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE is set, then we already have a
  # unique history, so in this case we do not need to do anything.
  #
  if [[ -o HIST_IGNORE_ALL_DUPS || -n $HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE ]]; then
    return
  fi

  if [[ -o HIST_FIND_NO_DUPS && $BUFFER == $_history_substring_search_result ]]; then
    #
    # Repeat the current search so that a different (unique) match is found.
    #
    _history-substring-search-down-search
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  fi
}

# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
