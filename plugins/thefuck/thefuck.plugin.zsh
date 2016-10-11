if [[ -z $commands[thefuck] ]]; then
    echo 'thefuck is not installed, you should "pip install thefuck" first'
    return -1
fi

# Register alias
[[ ! -a $ZSH_CACHE_DIR/thefuck ]] && thefuck --alias > $ZSH_CACHE_DIR/thefuck
source $ZSH_CACHE_DIR/thefuck

fuck-command-line() {
    local FUCK="$(THEFUCK_REQUIRE_CONFIRMATION=0 thefuck $(fc -ln -1 | tail -n 1) 2> /dev/null)"
    [[ -z $FUCK ]] && echo -n -e "\a" && return
    BUFFER=$FUCK
    zle end-of-line
}
zle -N fuck-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey "\e\e" fuck-command-line
