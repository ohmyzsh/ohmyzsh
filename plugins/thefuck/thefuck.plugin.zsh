if [[ -z $commands[thefuck] ]]; then
    echo 'thefuck is not installed, you should "pip install thefuck" first'
    return -1
fi

alias fuck='eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'
alias FUCK='fuck'

fuck-command-line() {
    FUCK="$(thefuck $(fc -ln -1 | tail -n 1) 2> /dev/null)"
    [[ -z $FUCK ]] && echo -n -e "\a" && return
    BUFFER=$FUCK
    zle end-of-line
}
zle -N fuck-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey "\e\e" fuck-command-line
