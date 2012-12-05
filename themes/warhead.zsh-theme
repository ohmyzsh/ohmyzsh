# warhead theme for oh-my-zsh

if [ $UID -eq 0 ]; then 
	BCOLOR=$fg_bold[red]
	PCOLOR=$fg_bold[yellow]
else 
	BCOLOR=$fg_bold[blue]
	PCOLOR=$fg[green]
fi


ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}[%{$reset_color%}%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}+%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT='%{$fg_bold[red]%}%(?..%?%1v )%{$fg_bold[white]%}%m %{$BCOLOR%}[%{$reset_color%}%{$PCOLOR%}%~%{$BCOLOR%}]$(git_prompt_info) %{$BCOLOR%}%# %{$reset_color%}'
