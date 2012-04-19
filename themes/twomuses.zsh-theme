#!/usr/bin/env zsh
#local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
#
# Joshua Keroes 2012 - Adds user@host to muse.zsh-theme

setopt promptsubst

autoload -U add-zsh-hook
# autoload -U colors && colors
zle_highlight=( default:bold )

USER_COLOR=$FG[067]
HOST_COLOR=$FG[244]
DIR_COLOR=$FG[060]
PROMPT_COLOR=$FG[077]

PROMPT_SUCCESS_COLOR=$FG[117]
PROMPT_FAILURE_COLOR=$FG[124]
PROMPT_VCS_INFO_COLOR=$FG[242]
GIT_DIRTY_COLOR=$FG[133]
GIT_CLEAN_COLOR=$FG[118]
GIT_PROMPT_INFO=$FG[012]
GIT_SHA_COLOR=$FG[117]

#RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$GIT_DIRTY_COLOR%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$GIT_CLEAN_COLOR%}✔"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$GIT_PROMPT_INFO%})"

ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[082]%}✚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[166]%}✹%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[160]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[220]%}➜%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[082]%}═%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[190]%}✭%{$reset_color%}"

PROMPT='%{$USER_COLOR%}%n%{$reset_color%}@%{$HOST_COLOR%}%m%{$WHITE%}:%{$DIR_COLOR%}%~%{$reset_color%}%{$PROMPT_COLOR%} ᐅ %{$reset_color%}'
RPROMPT='%{$GIT_SHA_COLOR%}$(git_prompt_short_sha) %{$GIT_PROMPT_INFO%}$(git_prompt_info) %{$GIT_DIRTY_COLOR%}$(git_prompt_status) %{$reset_color%}'
