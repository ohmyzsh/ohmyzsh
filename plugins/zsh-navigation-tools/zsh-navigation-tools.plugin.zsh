#!/usr/bin/env zsh

0="${(%):-%N}" # this gives immunity to functionargzero being unset
export ZNT_REPO_DIR="${0%/*}"
export ZNT_CONFIG_DIR="$HOME/.config/znt"

#
# Copy configs
#

if [[ ! -d "$HOME/.config" ]]; then
    command mkdir "$HOME/.config"
fi

if [[ ! -d "$ZNT_CONFIG_DIR" ]]; then
    command mkdir "$ZNT_CONFIG_DIR"
fi

# 9 files
unset __ZNT_CONFIG_FILES
typeset -ga __ZNT_CONFIG_FILES
set +A __ZNT_CONFIG_FILES n-aliases.conf n-env.conf n-history.conf n-list.conf n-panelize.conf n-cd.conf n-functions.conf n-kill.conf n-options.conf

# Check for random 2 files if they exist
# This will shift 0 - 7 elements
shift $(( RANDOM % 8 )) __ZNT_CONFIG_FILES
if [[ ! -f "$ZNT_CONFIG_DIR/${__ZNT_CONFIG_FILES[1]}" || ! -f "$ZNT_CONFIG_DIR/${__ZNT_CONFIG_FILES[2]}" ]]; then
    # Something changed - examine every file
    set +A __ZNT_CONFIG_FILES n-aliases.conf n-env.conf n-history.conf n-list.conf n-panelize.conf n-cd.conf n-functions.conf n-kill.conf n-options.conf
    unset __ZNT_CONFIG_FILE
    typeset -g __ZNT_CONFIG_FILE
    for __ZNT_CONFIG_FILE in "${__ZNT_CONFIG_FILES[@]}"; do
        if [[ ! -f "$ZNT_CONFIG_DIR/$__ZNT_CONFIG_FILE" ]]; then
            command cp "$ZNT_REPO_DIR/.config/znt/$__ZNT_CONFIG_FILE" "$ZNT_CONFIG_DIR"
        fi
    done
    unset __ZNT_CONFIG_FILE
fi

unset __ZNT_CONFIG_FILES

#
# Load functions
#

autoload n-aliases n-cd n-env n-functions n-history n-kill n-list n-list-draw n-list-input n-options n-panelize n-help
autoload znt-usetty-wrapper znt-history-widget znt-cd-widget znt-kill-widget
alias naliases=n-aliases ncd=n-cd nenv=n-env nfunctions=n-functions nhistory=n-history
alias nkill=n-kill noptions=n-options npanelize=n-panelize nhelp=n-help

zle -N znt-history-widget
bindkey '^R' znt-history-widget
setopt AUTO_PUSHD HIST_IGNORE_DUPS PUSHD_IGNORE_DUPS
zstyle ':completion::complete:n-kill::bits' matcher 'r:|=** l:|=*'

