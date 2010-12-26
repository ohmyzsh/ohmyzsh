
# setup basic prompt
local user="$(whoami)"

if [ "$user" = "root" ]; then 
    local user_host="%{$fg[yellow]%}_ROOT_%{$reset_color%}@%{$fg[red]%}$(~/scripts/shorthost)%{$reset_color%}"
    local prompt_color=red
elif [ "$user" = "komitee" ] || [ "$user" = "mkomitee" ]; then
    local user_host="%{$fg[red]%}%{$fg[yellow]%}@%{$fg[magenta]%}$(~/scripts/shorthost)%{$reset_color%}"
    local prompt_color=white
else 
    local user_host="%{$fg[yellow]%}%n%{$fg[blue]%}@%{$fg[magenta]%}$(~/scripts/shorthost)%{$reset_color%}"
    local prompt_color=yellow
fi

local prompt_char="%{$fg[$prompt_color]%}%#%{$reset_color%}"

PROMPT="%{$fg[cyan]%}[${user_host} %{$fg[yellow]%}%~%{$fg[cyan]%}]${prompt_char} "

# Setup vi mode indicator
MODE_INDICATOR="%{$fg_bold[yellow]%}<N>%{$reset_color%}"

# Setup git prompt info
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[red]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# setup command result indicator
CMDRESULT="%(?, ,%{$fg[red]%}[$?]%{$reset_color%})"

# setup right prompt
RPROMPT='$(git_prompt_info)${CMDRESULT}$(vi_mode_prompt_info)'

# vim: set ft=zsh
