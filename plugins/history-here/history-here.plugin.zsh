#!/usr/bin/zsh

# history-here zsh plugin
#   2019 @leonjza
#
# binds ^G to change the location where
# history gets written to from here on.
#
# This plugin checks the environment
# variable $HISTORY_HERE_AUTO_DIRS for a
# list of directories that should
# automatically have its history isolated.
# Matches are regex and checks if the pwd
# *contains* a string from the list. For
# this reason you should use the most 
# absolute path possible.
#
# Example:
#   export HISTORY_HERE_AUTO_DIRS=(/Users/foo/work /root/test)

_master_histfile=$HISTFILE
_hist_file_name=".zsh_history"
_history_here_is_global=true
_current_histfile=""

function history_here_toggle() {

    if [[ $_history_here_is_global == true ]]; then
       _history_here_set_isolated_history
    else
        _history_here_set_global_history
    fi
}

function _history_here_set_isolated_history() {

    local _pwd=`pwd`
    _current_histfile="$_pwd/$_hist_file_name"
    print -n "${fg[blue]}Using isolated history in this directory.${reset_color}"

    export HISTFILE=$_current_histfile
    _history_here_is_global=false
}

function _history_here_set_global_history() {

    print -n "${fg[green]}Using global history.${reset_color}"
    _current_histfile=""

    export HISTFILE=$_master_histfile
    _history_here_is_global=true
}

function _history_here_isolate_if_in_auto_change_dir() {

    local _pwd=`pwd`
    for d in $HISTORY_HERE_AUTO_DIRS; do
        if [[ "$_pwd" =~ $d ]]; then
            print "${fg[yellow]}Matched an auto history change directory:${reset_color} ${fg[green]}$d${reset_color}"
            _history_here_set_isolated_history 
            break
        fi
    done
}

# bind the toggle
autoload -Uz history_here_toggle
zle -N history_here_toggle
bindkey '^G' history_here_toggle

# bind to cd, checking $HISTORY_HERE_AUTO_DIRS 
autoload -U add-zsh-hook
add-zsh-hook chpwd _history_here_isolate_if_in_auto_change_dir
