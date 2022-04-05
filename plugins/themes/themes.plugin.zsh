<<<<<<< HEAD
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
=======
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
    {
        # Show themes inside $ZSH_CUSTOM (in any subfolder)
        # Strip $ZSH_CUSTOM/themes/ and $ZSH_CUSTOM/ from the name, so that it matches
        # the value that should be written in $ZSH_THEME to load the theme.
        print -l "$ZSH_CUSTOM"/**/*.zsh-theme(.N:r:gs:"$ZSH_CUSTOM"/themes/:::gs:"$ZSH_CUSTOM"/:::)

        # Show themes inside $ZSH, stripping the head of the path.
        print -l "$ZSH"/themes/*.zsh-theme(.N:t:r)
    } | sort -u | fmt -w $COLUMNS
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}
