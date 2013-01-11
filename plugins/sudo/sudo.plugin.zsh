sudo-command-line() {
    [[ -z "$BUFFER" ]] && zle up-history
    [[ "$BUFFER" != "sudo *" ]] && BUFFER="sudo $BUFFER"
    zle end-of-line
}
zle -N sudo-command-line
bindkey '\e\e' sudo-command-line
