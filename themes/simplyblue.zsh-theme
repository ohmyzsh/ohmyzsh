PROMPT='$(ssh_connection)%{$fg_bold[blue]%}%~ $(git_prompt_info)%{$fg_bold[yellow]%}➜ %{$reset_color%}'
RPROMPT='%{$fg_bold[blue]%}%T%{$reset_color%}'

function ssh_connection() {
	if [[ -n $SSH_CONNECTION ]]; then
		echo "%{$fg_bold[red]%}$(hostname) "
	fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
