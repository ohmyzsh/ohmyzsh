function theme
{
    if [ -z "$1" ] || [ "$1" = "random" ]; then
        themes=($(find $ZSH_CUSTOM $ZSH_CUSTOM/themes/ $ZSH/themes -name '*.zsh-theme'))
        N=${#themes[@]}
        ((N=(RANDOM%N)+1))
        RANDOM_THEME=${themes[$N]}
        source "$RANDOM_THEME"
        RANDOM_THEME_NAME=`echo "$RANDOM_THEME"|xargs -d '\n' -n 1 basename|sed 's/\(.*\)\..*/\1/'`
        echo "[oh-my-zsh] Random theme '$RANDOM_THEME_NAME' loaded."
    else
        if [ -f "$ZSH_CUSTOM/$1.zsh-theme" ]; then
            source "$ZSH_CUSTOM/$1.zsh-theme"
        elif [ -f "$ZSH_CUSTOM/themes/$1.zsh-theme" ]; then
            source "$ZSH_CUSTOM/themes/$1.zsh-theme"
        elif [ -f "$ZSH/themes/$1.zsh-theme" ]; then
            source "$ZSH/themes/$1.zsh-theme"
        else
            echo "[oh-my-zsh] Theme '$1' not found."
        fi
    fi
}

function lstheme
{
    find $ZSH_CUSTOM $ZSH_CUSTOM/themes/ $ZSH/themes -name '*.zsh-theme' \
    | xargs -d '\n' -n 1 basename \
    | sed 's/\(.*\)\..*/\1/' \
    | sort -u | column
}
