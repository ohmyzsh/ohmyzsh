if [[ "$USER" = 'root' ]]; then
	PROMPT=$'%{$fg[black]%}<<< %{$fg[white]%}%n %{$fg[red]%}at %{$fg[white]%}%m %{$fg[red]%}in %{$fg[white]%}%~ $(git_prompt_info)
%{$fg[red]%}>>> %{$reset_color%}'
	RPROMPT=$'%{$fg[black]%}%D{%T}%{$reset_color%}'

	ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}on %{$fg[white]%}"
	ZSH_THEME_GIT_PROMPT_SUFFIX=""
	ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*"
	ZSH_THEME_GIT_PROMPT_CLEAN=""
else
	PROMPT=$'%{$fg[black]%}<<< %{$fg[white]%}%n %{$fg[green]%}at %{$fg[white]%}%m %{$fg[green]%}in %{$fg[white]%}%~ $(git_prompt_info)
%{$fg[green]%}>>> %{$reset_color%}'
	RPROMPT=$'%{$fg[black]%}%D{%T}%{$reset_color%}'

	ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}on %{$fg[white]%}"
	ZSH_THEME_GIT_PROMPT_SUFFIX=""
	ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*"
	ZSH_THEME_GIT_PROMPT_CLEAN=""
fi