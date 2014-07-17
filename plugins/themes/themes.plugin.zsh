function theme
{
    if [ -z "$1" ]; then
        1="random"
    fi

    if [ -f "$ZSH_CUSTOM/$1.zsh-theme" ]
    then
        source "$ZSH_CUSTOM/$1.zsh-theme"
    elif [ -f "$ZSH_CUSTOM/themes/$1.zsh-theme" ]
    then
        source "$ZSH_CUSTOM/themes/$1.zsh-theme"
    else
        source "$ZSH/themes/$1.zsh-theme"
    fi
}

function lstheme
{
    # Resources:
    # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Modifiers
    # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Glob-Qualifiers
    print -l {$ZSH,$ZSH_CUSTOM}/themes/*.zsh-theme(N:t:r)
}
