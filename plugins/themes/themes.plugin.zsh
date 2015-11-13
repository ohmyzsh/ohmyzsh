THEMEPATH=("$ZSH_CUSTOM/themes" "$ZSH_CUSTOM" "$ZSH/themes")

function theme
{
    if [ -z "$1" ] || [ "$1" = "random" ]; then
	# Load every theme in the themepath
	# TODO remove the shadowed themes from the list
	# i.e: if I have a custom theme foo overshadowing
	# "$ZSH/themes/foo.zsh-theme", the latter shouldn't
	# be part of this list.
	themes=($(find $THEMEPATH -name '*.zsh-theme'))

	N=${#themes[@]}
	((N=(RANDOM%N)+1))
	random_theme=${themes[$N]}
	source "$random_theme"
	echo "[oh-my-zsh] Random theme '$random_theme' loaded."
    else
	theme_name="$1.zsh-theme"
	match=""
	for dir in $THEMEPATH
	do
	    # Keep looking until we find a matching theme
	    if [ -f "$dir/$theme_name" ] && [ -z "$match" ]
	    then
		match=$dir/$theme_name
	    fi
	done

	if [ -n "$match" ]
	then
	    source "$match"
	else
	    echo "[oh-my-zsh]Couldn't find theme $1."
	fi
    fi
}

function lstheme
{
    find $THEMEPATH -name '*.zsh-theme' | sort -u | sed 's:.*/\(.*\)\.zsh-theme:\1:'
}
