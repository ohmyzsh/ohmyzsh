#
# PROMPT
#
PROMPT_STYLE='%{$fg[red]%}❤ '
PROMPT_BRACKET_BEGIN='%{$fg[white]%}['
PROMPT_USER='%{$fg[blue]%}%n'
PROMPT_AT="%{$reset_color%}@"
PROMPT_HOST='%{$fg[red]%}%m'
PROMPT_SEPARATOR='%{$reset_color%}:'
PROMPT_DIR='%{$fg[blue]%}%~'
PROMPT_BRACKET_END='%{$fg[white]%}]'
PROMPT_SIGN='%{$reset_color%}%#'

GIT_PROMPT_INFO='$(git_prompt_info)'
GIT_PROMPT_STATUS='$(git_prompt_status)'

function prompt_char {
	git branch >/dev/null 2>/dev/null && echo '±' && return
	echo 'o'
}
function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

PROMPT="${PROMPT_STYLE}${PROMPT_BRACKET_BEGIN}${PROMPT_DIR}${PROMPT_BRACKET_END}${GIT_PROMPT_INFO}${GIT_PROMPT_STATUS}%{$reset_color%} "
#$(virtualenv_info)$(prompt_char)%{$reset_color%} "

#RPROMPT='$(~/.rvm/bin/rvm-prompt)'
RPROMPT="${PROMPT_USER}${PROMPT_AT}${PROMPT_HOST}%{$reset_color%}"
#
# Git repository
#
ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}%{$_reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} ⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[red]%} ♥%{$reset_color%}"


ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%}✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%}✭"
