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
# and Dieter[2], the implementation idea is from Bart Schaefer on the the zsh 
# mailing list[3].  The implementation is by Jim Hester in September 2012.
#
# [1]: http://www.compbiome.com/2010/07/bash-per-directory-bash-history.html
# [2]: http://dieter.plaetinck.be/per_directory_bash
# [3]: http://www.zsh.org/mla/users/1997/msg00226.html
#
################################################################################
#
# Copyright (c) 2012 Jim Hester
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

#-------------------------------------------------------------------------------
# toggle global/directory history used for searching - ctrl-G by default
#-------------------------------------------------------------------------------

function per-directory-history-toggle-history() {
  if [[ $_per_directory_history_is_global == true ]]; then
    _per-directory-history-set-directory-history
    print "\nusing local history\n"
  else
    _per-directory-history-set-global-history
    print "\nusing global history\n"
  fi
  zle .push-line
  zle .accept-line
}

autoload per-directory-history-toggle-history
zle -N per-directory-history-toggle-history
bindkey '^G' per-directory-history-toggle-history

#-------------------------------------------------------------------------------
# implementation details
#-------------------------------------------------------------------------------

_per_directory_history_directory="$HISTORY_BASE${PWD:A}/history"

function _per-directory-history-change-directory() {
  _per_directory_history_directory="$HISTORY_BASE${PWD:A}/history"
  mkdir -p ${_per_directory_history_directory:h}
  if [[ $_per_directory_history_is_global == false ]]; then
    #save to the global history
    fc -AI $HISTFILE
    #save history to previous file
    local prev="$HISTORY_BASE${OLDPWD:A}/history"
    mkdir -p ${prev:h}
    fc -AI $prev

    #discard previous directory's history
    local original_histsize=$HISTSIZE
    HISTSIZE=0
    HISTSIZE=$original_histsize
    
    #read history in new file
    if [[ -e $_per_directory_history_directory ]]; then
      fc -R $_per_directory_history_directory
    fi
  fi
}

function _per-directory-history-addhistory() {
  print -sr -- ${1%%$'\n'}
  fc -p $_per_directory_history_directory
}


function _per-directory-history-set-directory-history() {
  if [[ $_per_directory_history_is_global == true ]]; then
    fc -AI $HISTFILE
    local original_histsize=$HISTSIZE
    HISTSIZE=0
    HISTSIZE=$original_histsize
    if [[ -e "$_per_directory_history_directory" ]]; then
      fc -R "$_per_directory_history_directory"
    fi
  fi
  _per_directory_history_is_global=false
}
function _per-directory-history-set-global-history() {
  if [[ $_per_directory_history_is_global == false ]]; then
    fc -AI $_per_directory_history_directory
    local original_histsize=$HISTSIZE
    HISTSIZE=0
    HISTSIZE=$original_histsize
    if [[ -e "$HISTFILE" ]]; then
      fc -R "$HISTFILE"
    fi
  fi
  _per_directory_history_is_global=true
}


#add functions to the exec list for chpwd and zshaddhistory
chpwd_functions=(${chpwd_functions[@]} "_per-directory-history-change-directory")
zshaddhistory_functions=(${zshaddhistory_functions[@]} "_per-directory-history-addhistory")

#start in directory mode
mkdir -p ${_per_directory_history_directory:h}
_per_directory_history_is_global=true
_per-directory-history-set-directory-history
