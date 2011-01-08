
background-terminal() {
    if [ -z "$TERMINAL" ]; then
        xterm &
    else
        $TERMINAL &
    fi
}
zle -N background-terminal
bindkey -M vicmd "^N" background-terminal
bindkey -M viins "^N" background-terminal

