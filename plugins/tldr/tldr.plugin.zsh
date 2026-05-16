tldr-command-line() {
    # if there is no command typed, use the last command
    [[ -z "$BUFFER" ]] && zle up-history

    # if typed command begins with tldr, do nothing
    [[ "$BUFFER" = tldr\ * ]] && return

    # get command and possible subcommand
    # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion-Flags
    local -a args
    args=(${${(Az)BUFFER}[1]} ${${(Az)BUFFER}[2]})

    BUFFER="tldr ${args[1]}"
}

zle -N tldr-command-line
# Defined shortcut keys: [Esc]tldr
bindkey "\e"tldr tldr-command-line

