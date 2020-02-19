function theme {
    : ${1:=random} # Use random theme if none provided

    if [[ -f "$ZSH_CUSTOM/$1.zsh-theme" ]]; then
        source "$ZSH_CUSTOM/$1.zsh-theme"
    elif [[ -f "$ZSH_CUSTOM/themes/$1.zsh-theme" ]]; then
        source "$ZSH_CUSTOM/themes/$1.zsh-theme"
    elif [[ -f "$ZSH/themes/$1.zsh-theme" ]]; then
        source "$ZSH/themes/$1.zsh-theme"
    else
        echo "$0: Theme '$1' not found"
        return 1
    fi
}

function _theme {
    _arguments "1: :($(lstheme))"
}

compdef _theme theme

function lstheme {
    # Resources:
    # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Modifiers
    # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Glob-Qualifiers
    print "$ZSH_CUSTOM"/*.zsh-theme(N:t:r) {"$ZSH_CUSTOM","$ZSH"}/themes/*.zsh-theme(N:t:r)
}
