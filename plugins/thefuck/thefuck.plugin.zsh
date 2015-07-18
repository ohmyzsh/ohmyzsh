fuck-command-line() {
    FUCK=$(thefuck $(fc -ln -1 | tail -n 1) 2> /dev/null)
    [ -z $FUCK ] && echo -n -e "\a" && return
    BUFFER=$FUCK
    zle end-of-line
}
zle -N fuck-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey "\e\e" fuck-command-line
