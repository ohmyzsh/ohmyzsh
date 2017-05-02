# ZSH Theme
#  Author: Benjamin Beckwith (bnbeckwith@gmail.com)
# Version: 1.0
# Based on other ZSH themes: smt, norm, lambda

# Color each hostname differently with hashing
function color_host {
         echo `hostname | sha1sum | sed 's/[a-z]//g' | cut -c1-5 | awk '{printf "%03d\n", $1 % 256}'`
}

# Generate a color out of the hash
HOST_COLOR=$FG[$(color_host)]

MODE_INDICATOR="%{$fg_bold[red]%}❮%{$reset_color%}%{$fg[red]%}❮❮%{$reset_color%}"
local return_status="%{$fg[red]%}%(?..[%?])%{$reset_color%}"

# Two directories deep and then cut off the beginning.
PROMPT='%{$fg[blue]%}%2~/%{$reset_color%} $(git_prompt_info)$(git_prompt_status)
${return_status}%{$fg[blue]%}‸%{$reset_color%}'

# Simple time and hostname with hashed color
RPROMPT="%T%{$HOST_COLOR%}⁅%m⁆%{$reset_color%}"

# Most of below was stolen from smt.zsh-theme
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[red]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%}✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%}➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%}═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}✭"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"
