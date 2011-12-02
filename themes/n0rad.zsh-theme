#!/usr/bin/env zsh
# ------------------------------------------------------------------------------
#          FILE:  n0rad.zsh-theme
#   DESCRIPTION:  my zsh theme file.
#        AUTHOR:  n0rad (dev@norad.fr)
#          INFO:  not overloaded prompt with git_completion support if found
# ------------------------------------------------------------------------------

ZSH_THEME_GIT_PROMPT_ADDED="+"
ZSH_THEME_GIT_PROMPT_MODIFIED="!"
ZSH_THEME_GIT_PROMPT_DELETED="X"
ZSH_THEME_GIT_PROMPT_RENAMED=">"
ZSH_THEME_GIT_PROMPT_UNMERGED="±"
ZSH_THEME_GIT_PROMPT_UNTRACKED="?"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=" "

local return_status="%(?,%{$fg[green]%}▶%{$reset_color%},%{$fg_bold[red]%}▶%{$reset_color%})"
local prompthost="%(!.%{$fg_bold[red]%}%m%{$reset_color%}.%{$fg_bold[green]%}%n@%m%{$reset_color%})"

PROMPT2="%{$fg_bold[red]%}%_ %{$fg[green]%}▶%{$reset_color%} "

if type __git_ps1 >/dev/null 2>&1; then
    PROMPT='$prompthost %{$fg_bold[blue]%}%c%{$reset_color%} %{$fg_bold[yellow]%}$(git_prompt_status)%{$reset_color%}%{$fg[white]%}$(__git_ps1 "%s ")$return_status%{$reset_color%} '
else
    PROMPT='$prompthost %{$fg_bold[blue]%}%c%{$reset_color%} %{$fg_bold[yellow]%}$(git_prompt_status)%{$reset_color%}%{$fg[white]%}$(git_prompt_info)$return_status%{$reset_color%} '
fi
