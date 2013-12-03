# check if 'screen' is in TERM
SCR_COLOR=%{$fg[white]%}

if [ "$TERM" = "screen" ]; then
	SCR_COLOR=%{$fg[yellow]%}
fi

if [ "$TERM" = "screen-bce" ]; then
	SCR_COLOR=%{$fg[yellow]%}
fi

if [ "x$WINDOW" != "x" ]; then
	SCR_WINDOW="%{$fg[yellow]%}#$WINDOW"
elif [ "x$TMUX" != "x" ]; then
	SCR_WINDOW="%{$fg[yellow]%}#$(tmux display-message -p '#I')"
else
	SCR_WINDOW=""
fi

if [ "x$(battery_pct_prompt)" = "x" ]; then
	BATTERY=""
else
	BATTERY="$(battery_pct_prompt) "
fi
BATTERY=""

HOSTNAME=$(hostname)
HOSTCOLOUR=$(string_hash $HOSTNAME:l 15)

PROMPT='%{$reset_color%}%n%{$fg[white]%}@%{%F{$HOSTCOLOUR}%}%m$SCR_WINDOW$SCR_COLOR:%{$fg[blue]%}%~%{$reset_color%}$(git_prompt_info) %(0?,,%{$fg[red]%}%?!%{$reset_color%} )%(!.%{$fg[red]%}.%{$fg[green]%})%#%{$reset_color%} '

RPROMPT='$BATTERY%{$fg_bold[black]%}%*%{$reset_color%}'
# include aws_prompt if the ec2 plugin is loaded
if [ "x$AWS_PLUGIN" = "x1" ]; then
	RPROMPT='$(aws_prompt) '$RPROMPT
fi

ZSH_THEME_GIT_PROMPT_PREFIX=":%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%F{161}!%{$reset_color%}"

