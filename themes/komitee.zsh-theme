local user="$(whoami)"

if [ "$user" = "root" ]; then 
    local user_host="%{$fg[yellow]%}_ROOT_%{$reset_color%}@%{$fg[red]%}$(~/scripts/shorthost)"
    local prompt_color=red
elif [ "$user" = "komitee" ] || [ "$user" = "mkomitee" ]; then
    local user_host="%{$fg[red]%}%{$fg[yellow]%}@%{$fg[magenta]%}$(~/scripts/shorthost)"
    local prompt_color=white
else 
    local user_host="%{$fg[yellow]%}%n%{$fg[blue]%}@%{$fg[magenta]%}$(~/scripts/shorthost)"
    local prompt_color=green
fi

PROMPT="%{$fg[cyan]%}[${user_host} %{$fg[yellow]%}%~%{$fg[cyan]%}]%{$fg[$prompt_color]%}%%%{$reset_color%} "

MODE_INDICATOR="%{$fg_bold[yellow]%}<N>%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[red]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
RPROMPT='$(git_prompt_info)$(vi_mode_prompt_info)'

# vim: set ft=zsh
