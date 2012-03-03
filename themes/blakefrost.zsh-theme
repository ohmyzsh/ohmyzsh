#! /usr/bin/env zsh

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT='%1~%{$reset_color%}$(git_prompt_info) ★ %{$reset_color%}'
RPROMPT='%{$fg[blue]%}$(rbenv version | cut -d " " -f 1 | sed "s/-/ /g")%{$reset_color%}'
