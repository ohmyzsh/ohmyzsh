sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    [[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
    zle end-of-line
}
zle -N sudo-command-line
# [Esc] [Esc]
bindkey "\e\e" sudo-command-line

#[Esc][h] man
alias run-help >&/dev/null && unalias run-help
autoload run-help
