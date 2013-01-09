#!/usr/bin/env zsh
local USER_HOST='%{$terminfo[bold]$fg[yellow]%}%n@%m%{$reset_color%}'
local RETURN_CODE="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
local GIT_BRANCH='%{$terminfo[bold]$fg[red]%}$(git_prompt_info)%{$reset_color%}'
local CURRENT_DIR='%{$terminfo[bold]$fg[green]%} %~%{$reset_color%}'
local RUBY_RVM='%{$fg[gray]%}‹$(rvm-prompt i v g)›%{$reset_color%}'
local COMMAND_TIP='%{$terminfo[bold]$fg[blue]%}$(wget -qO - http://www.commandlinefu.com/commands/random/plaintext | sed 1d | sed '/^$/d' | sed 's/^/║/g')%{$reset_color%}'
######### PROMPT #########
PROMPT="%{$terminfo[bold]$fg[blue]%}╔═ %{$reset_color%}${USER_HOST} ${CURRENT_DIR} ${RUBY_RVM} ${GIT_BRANCH}
${COMMAND_TIP}
%{$terminfo[bold]$fg[blue]%}╚═ %{$reset_color%}%B%{$terminfo[bold]$fg[white]%}$%b%{$reset_color%} "
RPS1='${RETURN_CODE}'
RPROMPT='%{$fg[green]%}[%*]%{$reset_color%}'
######### PROMPT #########
########## GIT ###########
ZSH_THEME_GIT_PROMPT_PREFIX="‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$GIT_PROMPT_INFO%}›"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$GIT_DIRTY_COLOR%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$GIT_CLEAN_COLOR%}✔"
ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[082]%}✚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[166]%}✹%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[160]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[220]%}➜%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[082]%}═%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[190]%}✭%{$reset_color%}"
########## GIT ###########
