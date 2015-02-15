#!/bin/zsh

# Zsh Theme Chooser by fox (fox91 at anche dot no)
#
# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://sam.zoy.org/wtfpl/COPYING for more details.

# This is intended to be run in its own shell process, as a command
# To get it to work properly, you should set ZSH and ZSH_CUSTOM in its
# environment before running.
#
# Note that themes with both multi-line prompts and RPROMPTs may not display
# properly.

ZSH=${ZSH:-$HOME/.oh-my-zsh}
FAVLIST="${HOME}/.zsh_favlist"
source $ZSH/oh-my-zsh.sh


function noyes() {
    local a
    read "a?$1 [y/N] "
    if [[ $a == "N" || $a == "n" || $a = "" ]]; then
        return 0
    fi
    return 1
}

function theme_preview() {
    local THEME=$1
    print "$fg[blue]${(l.((${COLUMNS}-${#THEME}-5))..─.)}$reset_color $THEME $fg[blue]───$reset_color"
    theme $THEME
    cols=$(tput cols)
    #TODO: Figure out how to display RPROMPT correctly
    print -P "$PROMPT                                                                                      $RPROMPT"
}

function banner() {
    echo
    echo "[0;1;35;95m╺━[0;1;31;91m┓┏[0;1;33;93m━┓[0;1;32;92m╻[0m [0;1;36;96m╻[0m   [0;1;35;95m╺┳[0;1;31;91m╸╻[0m [0;1;33;93m╻[0;1;32;92m┏━[0;1;36;96m╸┏[0;1;34;94m┳┓[0;1;35;95m┏━[0;1;31;91m╸[0m   [0;1;32;92m┏━[0;1;36;96m╸╻[0m [0;1;34;94m╻[0;1;35;95m┏━[0;1;31;91m┓┏[0;1;33;93m━┓[0;1;32;92m┏━[0;1;36;96m┓┏[0;1;34;94m━╸[0;1;35;95m┏━[0;1;31;91m┓[0m"
    echo "[0;1;31;91m┏━[0;1;33;93m┛┗[0;1;32;92m━┓[0;1;36;96m┣━[0;1;34;94m┫[0m    [0;1;31;91m┃[0m [0;1;33;93m┣[0;1;32;92m━┫[0;1;36;96m┣╸[0m [0;1;34;94m┃[0;1;35;95m┃┃[0;1;31;91m┣╸[0m    [0;1;36;96m┃[0m  [0;1;34;94m┣[0;1;35;95m━┫[0;1;31;91m┃[0m [0;1;33;93m┃┃[0m [0;1;32;92m┃[0;1;36;96m┗━[0;1;34;94m┓┣[0;1;35;95m╸[0m [0;1;31;91m┣┳[0;1;33;93m┛[0m"
    echo "[0;1;33;93m┗━[0;1;32;92m╸┗[0;1;36;96m━┛[0;1;34;94m╹[0m [0;1;35;95m╹[0m    [0;1;33;93m╹[0m [0;1;32;92m╹[0m [0;1;36;96m╹[0;1;34;94m┗━[0;1;35;95m╸╹[0m [0;1;31;91m╹[0;1;33;93m┗━[0;1;32;92m╸[0m   [0;1;34;94m┗━[0;1;35;95m╸╹[0m [0;1;31;91m╹[0;1;33;93m┗━[0;1;32;92m┛┗[0;1;36;96m━┛[0;1;34;94m┗━[0;1;35;95m┛┗[0;1;31;91m━╸[0;1;33;93m╹┗[0;1;32;92m╸[0m"
    echo
}

function usage() {
    local EXIT_STATUS=$1
    echo \
"Usage: $TOOL_NAME [options] [theme]
Options:
  -s   Show (preview) all themes
  -l   List available themes
  -a   List current favourite list contents
  -h   Display this help message

If [theme] is supplied, previews that single theme.
If no option and no argument is given, previews all themes in turn, giving user
the option to add each to their favourites list.
If you have a custom ZSH or ZSH_CUSTOM directory defined, you should pass that in
via environment variables. For example: 
   ZSH=\$ZSH ZSH_CUSTOM=\$ZSH_CUSTOM $TOOL_NAME"

    exit $EXIT_STATUS
}

function list_themes() {
    lstheme
}

function insert_favlist() {
    local THEME=$1
    #TODO: This simple grep will match substrings of theme names, not just full names
    if grep -q $THEME $FAVLIST 2> /dev/null ; then
        echo "Already in favlist: $THEME"
    else
        echo $THEME >> $FAVLIST
        echo "Added to favlist: $THEME"
    fi
}

function theme_chooser() {
    local THEME
    if [[ -z $1 ]]; then
        echo "Updating favourite list at $FAVLIST"
    fi
    for THEME in $(lstheme); do
        echo
        theme_preview $THEME
        echo
        if [[ -z $1 ]]; then
            noyes "Do you want to add it to your favourite list" || \
                  insert_favlist $THEME
            echo
        fi
    done
}

function list_favlist() {
    if [[ -f $FAVLIST ]]; then
        cat $FAVLIST
    fi
    return 0;
}

TOOL_NAME=${0##*/}
while getopts ":lhas" OPTION; do
  case $OPTION in
    l ) list_themes ;;
    s ) theme_chooser 0 ;;
    a ) list_favlist ;;
    h ) usage 0 ;;
    * ) echo "Unrecognized option" >&2; usage 1 ;;
  esac
done

if [[ -z $OPTION ]]; then
    if [[ -z $1 ]]; then
        banner
        echo
        theme_chooser
    else
        theme_preview $1
    fi
fi
