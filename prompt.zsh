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

PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
