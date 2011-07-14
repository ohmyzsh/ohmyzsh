if [[ -n `which dircolors` ]];then
	eval `dircolors -b`
	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

plugins(){
	oUT=""

	if [ -n "`which git_prompt_info`" ] ; then
		OUT=`git_prompt_info`
	fi

	echo " $OUT"
}

screen_window(){
	if [ -n "$WINDOW" ]; then
		echo "%{$reset_color%}%{$fg_bold[grey]%}/ %{$fg[red]%}$WINDOW%{$reset_color%} "
	fi
}

PROMPT='%{$fg_bold[grey]%}[%{$reset_color%}%{$fg[cyan]%}%~%{$fg_bold[grey]%}] %{$fg_bold[grey]%}$ %{$reset_color%}'
RPROMPT='%{$reset_color%}`plugins` %{$fg_bold[grey]%}[%f%{$fg_bold[blue]%}%n%{$reset_color%}%{$fg[green]%}@%{$fg[cyan]%}%m %{$reset_color%}%{$fg[green]%}+$SHLVL `screen_window`%{$fg_bold[grey]%}]%{$reset_color%} %{$fg_bold[grey]%}[%{$reset_color%}%{$fg[cyan]%}%T%{$fg_bold[grey]%}]%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="$(git_prompt_status)%{$fg_bold[white]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg_bold[green]%}✔"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%}✈"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}✭"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%}✗"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}➦"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%}✂"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[grey]%}✱"
