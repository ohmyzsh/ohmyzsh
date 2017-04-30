function prompt_char {
	if [ $UID -eq 0 ]; then echo "#"; else echo "%%"; fi
}

PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}%n) %{$fg_bold[blue]%}%(!.%1~.%~) $(git_prompt_info)%_%{$fg_bold[magenta]%}$(prompt_char)%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[red]%}✗%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg_bold[green]%}✓%{$fg[yellow]%}"
