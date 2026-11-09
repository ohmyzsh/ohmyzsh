#!/usr/bin/env zsh
#
# This is a implementation of per directory history for zsh, some
# implementations of which exist in bash[1,2].  It also implements
# a per-directory-history-toggle-history function to change from using the
# directory history to using the global history.  In both cases the history is
# always saved to both the global history and the directory history, so the
# toggle state will not effect the saved histories.  Being able to switch
# between global and directory histories on the fly is a novel feature as far
# as I am aware.
#
#-------------------------------------------------------------------------------
# Configuration
#-------------------------------------------------------------------------------
#
# HISTORY_BASE a global variable that defines the base directory in which the
# directory histories are stored
#
#-------------------------------------------------------------------------------
# History
#-------------------------------------------------------------------------------
#
# The idea/inspiration for a per directory history is from Stewart MacArthur[1]
# and Dieter[2], the implementation idea is from Bart Schaefer on the zsh
# mailing list[3].  The implementation is by Jim Hester in September 2012.
#
# [1]: http://www.compbiome.com/2010/07/bash-per-directory-bash-history.html
# [2]: http://dieter.plaetinck.be/per_directory_bash
# [3]: http://www.zsh.org/mla/users/1997/msg00226.html
#
################################################################################
#
# Copyright (c) 2014 Jim Hester
#
# This software is provided 'as-is', without any express or implied warranty.
# In no event will the authors be held liable for any damages arising from the
# use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must not claim
# that you wrote the original software. If you use this software in a product,
# an acknowledgment in the product documentation would be appreciated but is
# not required.
#
# 2. Altered source versions must be plainly marked as such, and must not be
# misrepresented as being the original software.
#
# 3. This notice may not be removed or altered from any source distribution..
#
################################################################################

#-------------------------------------------------------------------------------
# configuration, the base under which the directory histories are stored
#-------------------------------------------------------------------------------

[[ -z $HISTORY_BASE ]] && HISTORY_BASE="$HOME/.directory_history"
[[ -z $HISTORY_START_WITH_GLOBAL ]] && HISTORY_START_WITH_GLOBAL=false
[[ -z $PER_DIRECTORY_HISTORY_TOGGLE ]] && PER_DIRECTORY_HISTORY_TOGGLE='^G'
[[ -z $PER_DIRECTORY_HISTORY_PRINT_MODE_CHANGE ]] && PER_DIRECTORY_HISTORY_PRINT_MODE_CHANGE=true

#-------------------------------------------------------------------------------
# toggle global/directory history used for searching - ctrl-G by default
#-------------------------------------------------------------------------------

function per-directory-history-toggle-history() {
  if [[ $_per_directory_history_is_global == true ]]; then
    _per-directory-history-set-directory-history
    _per_directory_history_is_global=false
    if [[ $PER_DIRECTORY_HISTORY_PRINT_MODE_CHANGE == true ]]; then
      zle -M "using local history"
    fi
  else
    _per-directory-history-set-global-history
    _per_directory_history_is_global=true
    if [[ $PER_DIRECTORY_HISTORY_PRINT_MODE_CHANGE == true ]]; then
      zle -M "using global history"
    fi
  fi
}

autoload per-directory-history-toggle-history
zle -N per-directory-history-toggle-history
bindkey $PER_DIRECTORY_HISTORY_TOGGLE per-directory-history-toggle-history
bindkey -M vicmd $PER_DIRECTORY_HISTORY_TOGGLE per-directory-history-toggle-history

#-------------------------------------------------------------------------------
# implementation details
#-------------------------------------------------------------------------------

_per_directory_history_directory="$HISTORY_BASE${PWD:A}/history"
_per_directory_history_global="$HISTFILE"
# history file of the currently active history context, empty until the
# first history context switch
_per_directory_history_active=""

# Switch the active history to the file given as argument: commands that were
# not written yet are appended to the previously active history file, and the
# new file is read in if it exists. The base history is prevented from
# rewriting the global history file when the history contexts are destroyed
# (on exit), so both history files are only ever appended to by this plugin.
function _per-directory-history-switch-history() {
  local original_histsize=$HISTSIZE
  local original_savehist=$SAVEHIST

  if [[ -n "$_per_directory_history_active" ]]; then
    # append the commands that were not written yet to the outgoing history
    fc -AI "$_per_directory_history_active"
    # pop the outgoing history context without writing it again
    HISTFILE=
    SAVEHIST=0
    fc -P
  else
    # append the commands entered so far to the global history, and prevent
    # the base history from rewriting the global history file on exit
    fc -AI "$_per_directory_history_global"
    SAVEHIST=0
  fi

  # start the new active history; the file is read in if it exists
  fc -p "$1"
  HISTSIZE=$original_histsize
  SAVEHIST=$original_savehist
  _per_directory_history_active="$1"
}

function _per-directory-history-change-directory() {
  _per_directory_history_directory="$HISTORY_BASE${PWD:A}/history"
  mkdir -p ${_per_directory_history_directory:h}
  if [[ $_per_directory_history_is_global == false ]]; then
    # switch the active history to the new directory's history
    _per-directory-history-switch-history "$_per_directory_history_directory"
  fi
}

function _per-directory-history-addhistory() {
  # zsh itself adds the accepted command to the active history, so it does
  # not need to be added again with print -S here: doing so would store the
  # command twice (visible as duplicated entries when hist_ignore_dups is
  # not set). This hook only rejects commands that must not be saved at all:
  # a zshaddhistory hook returning 1 is the documented way to keep a command
  # out of the history, so hist_ignore_space is honored by returning 1.
  if [[ -o hist_ignore_space ]] && [[ "$1" == \ * ]]; then
      return 1
  fi
  return 0
}

function _per-directory-history-preexec() {
  # Save the command also to the history file that is not the active one, so
  # that both the global and the per-directory histories always receive every
  # command, whichever history is active (see issue #11198).
  if [[ -o hist_ignore_space ]] && [[ "$1" == \ * ]]; then
      return 0
  fi

  local inactive_history
  if [[ $_per_directory_history_is_global == true ]]; then
    inactive_history="$_per_directory_history_directory"
  else
    inactive_history="$_per_directory_history_global"
  fi

  # Append the command in an isolated history context, so the active history
  # is not disturbed. fc -p pushes a new history list and fc -P pops it after
  # the command was appended to the inactive history file.
  fc -p "$inactive_history" "$HISTSIZE" "$SAVEHIST"
  print -Sr -- "$1"
  fc -AI "$inactive_history"
  # prevent the isolated history context from being written when it is popped
  HISTFILE=
  SAVEHIST=0
  fc -P
}

function _per-directory-history-precmd() {
  if [[ $_per_directory_history_initialized == false ]]; then
    _per_directory_history_initialized=true

    if [[ $HISTORY_START_WITH_GLOBAL == true ]]; then
      _per-directory-history-set-global-history
      _per_directory_history_is_global=true
    else
      _per-directory-history-set-directory-history
      _per_directory_history_is_global=false
    fi
  fi
}

function _per-directory-history-set-directory-history() {
  _per-directory-history-switch-history "$_per_directory_history_directory"
}

function _per-directory-history-set-global-history() {
  _per-directory-history-switch-history "$_per_directory_history_global"
}

mkdir -p ${_per_directory_history_directory:h}

#add functions to the exec list for chpwd, zshaddhistory, preexec and precmd
autoload -U add-zsh-hook
add-zsh-hook chpwd _per-directory-history-change-directory
add-zsh-hook zshaddhistory _per-directory-history-addhistory
add-zsh-hook preexec _per-directory-history-preexec
add-zsh-hook precmd _per-directory-history-precmd

# set initialized flag to false
_per_directory_history_initialized=false
