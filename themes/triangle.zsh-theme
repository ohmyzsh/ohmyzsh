local chroot_status="${debian_chroot:+($debian_chroot)}"
local return_status="%(?:%{$fg_bold[green]%}∆:%{$fg_bold[red]%}∇)%{$reset_color%}"
if [[ -n "$SSH_CLIENT" ]]; then
    local user='$(whoami)'
    local user_prompt="${user}@%m : "
fi
local prompt_end="%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%})%(!:#:❯)%{$reset_color%}"

PROMPT="${chroot_status}${return_status} ${user_prompt}%~ ${prompt_end} "

local git_status='$(parse_git_dirty)$(git_prompt_info)%{$reset_color%} $(git_remote_status)'

RPROMPT="${git_status}"

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="%{$fg_bold[yellow]%}↓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$fg_bold[green]%}↑%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="%{$fg_bold[red]%}⇵%{$reset_color%}"
