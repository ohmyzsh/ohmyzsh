export PAGER=less
export LC_CTYPE=en_US.UTF-8

# speed stuff.

#setopt no_beep
setopt auto_cd
setopt multios
setopt cdablevarS

if [[ x$WINDOW != x ]]
then
    SCREEN_NO="%B$WINDOW%b "
else
    SCREEN_NO=""
fi

PS1="%n@%m:%~%# "

# Setup the prompt with pretty colors
setopt prompt_subst

export LSCOLORS="Gxfxcxdxbxegedabagacad"

function oh_my_zsh_theme_precmd() {
  # Blank function; override this in your themes
}

source "$ZSH/themes/$ZSH_THEME.zsh-theme"
