# Oh My Zsh theme from https://github.com/Larandar/ 
# Other ZSH can maybe be on my Github
# Inspirations : Bira, Gentoo, Lambda, Miloshadzic and Sorin

function __custom_git_prompt() {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	ZSH_GIT_BRANCH="${ref#refs/heads/}"
	
	if [ -d $PWD/.git ] ; then
		ZSH_GIT_REPO=$(basename $PWD)
	else
		ZSH_GIT_REPO="$(basename $(dirname $(git rev-parse --git-dir)))"
	fi
	
	ZSH_GIT_DIRTY="$(parse_git_dirty)"
	[ ${ZSH_GIT_DIRTY} ] && ZSH_GIT_DIRTY+=" " && ZSH_GIT_STATUT="${ZSH_COLOR_BASE}[ $(git_prompt_status) ${ZSH_COLOR_BASE}]"
	
	echo " ${ZSH_COLOR_BASE}git:{ ${ZSH_COLOR_GIT_REPO}${ZSH_GIT_REPO}${ZSH_COLOR_BASE} @ ${ZSH_COLOR_GIT_BRANCH}${ZSH_GIT_BRANCH}${ZSH_COLOR_BASE} ${ZSH_GIT_DIRTY}${COLOR_BASE}}${ZSH_GIT_STATUT}"
}

function __custom_prompt() {
	echo "$(__custom_git_prompt)"
}

ZSH_COLOR_VOID="%{$reset_color%}"
ZSH_COLOR_BASE="%{%F{3}%}"
ZSH_COLOR_SUB1="%{%F{4}%}"
ZSH_COLOR_SUB2="%{%F{5}%}"
ZSH_COLOR_RBASE="%{%F{13}%}"

ZSH_COLOR_GIT_REPO="%{%F{6}%}"
ZSH_COLOR_GIT_BRANCH="%{%F{9}%}"

ZSH_COLOR_ERROR="%{%F{1}%}"
ZSH_COLOR_HOST="${ZSH_COLOR_RBASE}"
ZSH_COLOR_RESET="${ZSH_COLOR_BASE}"


ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}⚡${ZSH_COLOR_RESET}"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%}✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}|"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}✭"

PROMPT="${ZSH_COLOR_BASE}╭─[ ${ZSH_COLOR_SUB1}%n${ZSH_COLOR_BASE} @${ZSH_COLOR_HOST}%m${ZSH_COLOR_BASE} ] ${ZSH_COLOR_SUB2}%2~${ZSH_COLOR_BASE} \$(__custom_git_prompt)
${ZSH_COLOR_BASE}╰─ ${ZSH_COLOR_SUB1} %{%b%}${ZSH_COLOR_VOID}"

return_code="%(?..${ZSH_COLOR_ERROR}%? ↵${ZSH_COLOR_VOID})"
RPROMPT="${return_code}${ZSH_COLOR_VOID} ${ZSH_COLOR_RBASE}!%!${ZSH_COLOR_VOID}"
