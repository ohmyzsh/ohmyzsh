function theme
{
    if [ -z "$1" ]; then
        1="random"
    fi

    if [ -f "$ZSH_CUSTOM/$1.zsh-theme" ]
    then
        source "$ZSH_CUSTOM/$1.zsh-theme"
    else
        source "$ZSH/themes/$1.zsh-theme"
    fi
}

function lstheme
{
    cd $ZSH/themes
    ls *zsh-theme | sed 's,\.zsh-theme$,,'
}
