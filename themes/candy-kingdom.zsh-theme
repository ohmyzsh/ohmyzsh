# neuralsanwich.zsh-theme
#
# Author: Sean Jones
# URL: http://www.neuralsandwich.com
# Repo: 
# Direct link:
# Create:
# Modified: 

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

PROMPT='
%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}$(box_name)%{$reset_color%}:%{$fg_bold[green]%}${PWD/#$HOME/~}%{$reset_color%}$(git_prompt_info)
%(?,,%{${fg_bold[white]}%}[%?]%{$reset_color%} )$ '

ZSH_THEME_GIT_PROMPT_PREFIX=" (%{$fg[magenta]%}branch: "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}?"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[orange]%}!"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"

local return_status="%{$fg[red]%}%(?..✘)%{$reset_color%}"
RPROMPT='${return_status}$(battery_time_remaining) $(battery_pct_prompt)%{$reset_color%}'
