export PAGER=less
export LC_CTYPE=en_US.UTF-8

bindkey -e

# Directory stuff.
setopt AUTO_NAME_DIRS

# Speed stuff.

#setopt NO_BEEP
setopt AUTO_CD
setopt MULTIOS
setopt CDABLEVARS

bindkey -e

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

source "$ZSH/themes/$ZSH_THEME.zsh-theme"
