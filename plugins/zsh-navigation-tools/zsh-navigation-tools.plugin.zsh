#!/usr/bin/env zsh

REPO_DIR="${0%/*}"
CONFIG_DIR="$HOME/.config/znt"

#
# Copy configs
#

if ! test -d "$HOME/.config"; then
    mkdir "$HOME/.config"
fi

if ! test -d "$CONFIG_DIR"; then
    mkdir "$CONFIG_DIR"
fi

# 9 files
set n-aliases.conf n-env.conf n-history.conf n-list.conf n-panelize.conf n-cd.conf n-functions.conf n-kill.conf n-options.conf

# Check for random 2 files if they exist
# This will shift 0 - 7 elements
shift $(( RANDOM % 8 ))
if ! test -f "$CONFIG_DIR/$1" || ! test -f "$CONFIG_DIR/$2"; then
    # Something changed - examine every file
    set n-aliases.conf n-env.conf n-history.conf n-list.conf n-panelize.conf n-cd.conf n-functions.conf n-kill.conf n-options.conf
    for i; do
        if ! test -f "$CONFIG_DIR/$i"; then
            cp "$REPO_DIR/.config/znt/$i" "$CONFIG_DIR"
        fi
    done
fi

# Don't leave positional parameters being set
set --

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

