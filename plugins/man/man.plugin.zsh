# ------------------------------------------------------------------------------
# Author
# ------
#
# * Jerry Ling<jerryling315@gmail.com>
#
# ------------------------------------------------------------------------------
# Usage
# -----
#
# man will be inserted before the command
#
# ------------------------------------------------------------------------------

man-command-line() {
    # if there is no command typed, use the last command
    [[ -z "$BUFFER" ]] && zle up-history

    # if typed command begins with man, do nothing
    [[ "$BUFFER" = man\ * ]] && return

    # get command and possible subcommand
    # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion-Flags
    local -a args
    args=(${${(Az)BUFFER}[1]} ${${(Az)BUFFER}[2]})

    # check if man page exists for command and first argument
    if man "${args[1]}-${args[2]}" >/dev/null 2>&1; then
        BUFFER="man $args"
    else
        BUFFER="man ${args[1]}"
    fi
}

zle -N man-command-line
# Defined shortcut keys: [Esc]man
bindkey "\e"man man-command-line
