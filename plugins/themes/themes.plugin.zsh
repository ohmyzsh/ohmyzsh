function theme
{
    if [ -z "$1" ] || [ "$1" = "random" ]; then
        themes=($ZSH/themes/*zsh-theme)
        N=${#themes[@]}
        ((N=(RANDOM%N)+1))
        RANDOM_THEME=${themes[$N]}
        source "$RANDOM_THEME"
        echo "[oh-my-zsh] Random theme '$RANDOM_THEME' loaded..."
    else
        if [ -f "$ZSH_CUSTOM/themes/$1.zsh-theme" ]
        then
            source "$ZSH_CUSTOM/themes/$1.zsh-theme"
        elif [ -f "$ZSH_CUSTOM/$1.zsh-theme" ]
        then
            source "$ZSH_CUSTOM/$1.zsh-theme"
        else
            source "$ZSH/themes/$1.zsh-theme"
        fi
    fi
}

function lstheme
{
    # default themes
    ls $ZSH/themes | grep '.zsh-theme$' | sed 's,\.zsh-theme$,,'

    # custom themes
    ls $ZSH_CUSTOM | grep '.zsh-theme$' | sed 's,\.zsh-theme$,,'

    if [ -d "$ZSH_CUSTOM/themes" ]
    then
        ls $ZSH_CUSTOM/themes | grep '.zsh-theme$' | sed 's,\.zsh-theme$,,'
    fi
}
