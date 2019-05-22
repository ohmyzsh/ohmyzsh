local ret_status="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)"
PROMPT='${ret_status} %{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)%{$fg_bold[magenta]%}%(!.#.»)%{$reset_color%} '
eval my_gray='$FG[240]'

# right prompt
if type "virtualenv_prompt_info" > /dev/null
then
	RPROMPT='$(virtualenv_prompt_info)$my_gray%D %*%{$reset_color%}%'
else
	RPROMPT='$my_gray%D %*%{$reset_color%}%'
fi

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}%{$fg[yellow]%}✗%{$fg[blue]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
