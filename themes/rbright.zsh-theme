#!/usr/bin/env zsh

local time_of_day='%{$fg_bold[blue]%}%T%{$reset_color%}'
local user_host='%{$fg_bold[green]%}%n@%m%{$reset_color%}'
local current_dir='%{$fg_bold[cyan]%}%c%{$reset_color%}'
local git_prompt='$(git_prompt_info)'

PROMPT="${time_of_day} ${user_host}:${current_dir} ${git_prompt} 
%# "

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[yellow]%}⚡"
ZSH_THEME_GIT_PROMPT_CLEAN=""
