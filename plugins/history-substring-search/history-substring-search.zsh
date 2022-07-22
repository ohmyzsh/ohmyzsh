#!/usr/bin/env zsh
##############################################################################
#
# Copyright (c) 2009 Peter Stephenson
# Copyright (c) 2011 Guido van Steen
# Copyright (c) 2011 Suraj N. Kurapati
# Copyright (c) 2011 Sorin Ionescu
# Copyright (c) 2011 Vincent Guerci
# Copyright (c) 2016 Geza Lore
# Copyright (c) 2017 Bengt Brodersen
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

#-----------------------------------------------------------------------------
# the main ZLE widgets
#-----------------------------------------------------------------------------

history-substring-search-up() {
  _history-substring-search-begin

  _history-substring-search-up-history ||
  _history-substring-search-up-buffer ||
  _history-substring-search-up-search

  _history-substring-search-end
}

history-substring-search-down() {
  _history-substring-search-begin

  _history-substring-search-down-history ||
  _history-substring-search-down-buffer ||
  _history-substring-search-down-search

  _history-substring-search-end
}

zle -N history-substring-search-up
zle -N history-substring-search-down

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
    CURSOR=${#BUFFER}
  fi

  # highlight command line using zsh-syntax-highlighting
  _zsh_highlight

  # highlight the search query inside the command line
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
  fi

  # For debugging purposes:
  # zle -R "mn: "$_history_substring_search_match_index" m#: "${#_history_substring_search_matches}
  # read -k -t 200 && zle -U $REPLY

  # Exit successfully from the history-substring-search-* widgets.
  return 0
}

_history-substring-search-up-buffer() {
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
    return 0
  fi

  return 1
}

_history-substring-search-down-buffer() {
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
    return 0
  fi

  return 1
}

_history-substring-search-up-history() {
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
      zle up-line-or-history
    fi

    return 0
  fi

  return 1
}

_history-substring-search-down-history() {
  #
  # Behave like down-history in ZSH, except clear the
  # $BUFFER when end of history is reached like in Fish.
  #
  if [[ -z $_history_substring_search_query ]]; then

    # going down from the absolute top of history
    if [[ $HISTNO -eq 1 && -z $BUFFER ]]; then
      BUFFER=${history[1]}
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
  fi
}

# -*- mode: zsh; sh-indentation: 2; indent-tabs-mode: nil; sh-basic-offset: 2; -*-
# vim: ft=zsh sw=2 ts=2 et
