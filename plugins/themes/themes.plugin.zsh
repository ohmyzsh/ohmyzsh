function theme
{
    if [ -z "$1" ] || [ "$1" = "random" ]; then
	if [ -f "$THEMES_FILE" ]; then
	    echo "[oh-my-zsh] Found custom theme file $THEMES_FILE"
	    themes=($(<$THEMES_FILE))
	    alias oh-my-zsh-theme-remove='echo "Removing theme ${themes[$N]}" ; sed -i.old "/$(basename ${themes[$N]})/d" $THEMES_FILE'
	else
		themes=($ZSH/themes/*zsh-theme)
	fi
	N=${#themes[@]}
	((N=(RANDOM%N)+1))
	RANDOM_THEME=${themes[$N]}
	if [ -f "$THEMES_FILE" ]; then
	    RANDOM_THEME="$ZSH/themes/$RANDOM_THEME"
	fi
	source "$RANDOM_THEME"
	echo "[oh-my-zsh] Random theme '$RANDOM_THEME' loaded..."
    else
	if [ -f "$ZSH_CUSTOM/$1.zsh-theme" ]
	then
	    source "$ZSH_CUSTOM/$1.zsh-theme"
	else
	    source "$ZSH/themes/$1.zsh-theme"
	fi
    fi
}

function lstheme
{
    cd $ZSH/themes
    ls *zsh-theme | sed 's,\.zsh-theme$,,'
}
