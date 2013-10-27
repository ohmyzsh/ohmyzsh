local USER_HOST='%{$fg_bold[yellow]%}%n@%m%{$reset_color%}'
local CURRENT_DIR=''
local USER_HOST='%{$fg[magenta]%}%n%{$reset_color%} at %{$fg[yellow]%}%m%{$reset_color%}'
REMOTE_CONN=''

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    REMOTE_CONN="%{$fg[magenta]%}✭%{$reset_color%} "
fi

PROMPT='[${REMOTE_CONN}%{$fg_bold[yellow]%}%n@%m%{$reset_color%}%{$fg_bold[green]%} ${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_info)%{$reset_color%}]%{$fg_bold[green]%}
: %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" git(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$GIT_CLEAN_COLOR%}✔"

# ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[082]%}✚%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[166]%}✹%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[160]%}✖%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[220]%}➜%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[082]%}═%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[190]%}✭%{$reset_color%}"

#!/usr/bin/env zsh
# local USER_HOST='%{$terminfo[bold]$fg[yellow]%}%n@%m%{$reset_color%}'
# local RETURN_CODE="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
# local GIT_BRANCH='%{$terminfo[bold]$fg[red]%}$(git_prompt_info)%{$reset_color%}'
# local CURRENT_DIR='%{$terminfo[bold]$fg[green]%} %~%{$reset_color%}'
# ######### PROMPT #########
# PROMPT="%{$terminfo[bold]$fg[blue]%}╔═ %{$reset_color%}${USER_HOST} ${CURRENT_DIR} ${GIT_BRANCH}

# %{$terminfo[bold]$fg[blue]%}╚═ %{$reset_color%}%B%{$terminfo[bold]$fg[white]%}$%b%{$reset_color%} "
# RPS1='${RETURN_CODE}'
# RPROMPT='%{$fg[green]%}[%*]%{$reset_color%}'
# ######### PROMPT #########
# ########## GIT ###########
# ZSH_THEME_GIT_PROMPT_PREFIX="‹"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$GIT_PROMPT_INFO%}›"
# ZSH_THEME_GIT_PROMPT_DIRTY=" %{$GIT_DIRTY_COLOR%}✘"
# ZSH_THEME_GIT_PROMPT_CLEAN=" %{$GIT_CLEAN_COLOR%}✔"
# ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[082]%}✚%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[166]%}✹%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[160]%}✖%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[220]%}➜%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[082]%}═%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[190]%}✭%{$reset_color%}"
# ########## GIT ###########
