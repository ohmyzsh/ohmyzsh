function do_RPROMPT()
{
	RPROMPT='$(git_prompt_status)$(git_prompt_info)'
}

function do_PROMPT()
{
	local user='%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}%n@)'
	local host='%m%{$reset_color%}'
	local dir='%{$fg_bold[blue]%}%~%{$reset_color%}%(!.#.$) '
	PROMPT="${user}${host}:${dir}"
}

ZSH_THEME_GIT_PROMPT_STATUS_PREFIX="%{$fg_bold[red]%}["
ZSH_THEME_GIT_PROMPT_STATUS_SUFFIX=""

ZSH_THEME_GIT_PROMPT_ADDED="✚%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="✹%{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_DELETED="✖%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_RENAMED="➜%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="═%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="✭%{$fg_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_NOTHING=""

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[red]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

do_PROMPT
do_RPROMPT
