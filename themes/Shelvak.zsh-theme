# Shelvak.zsh-theme
#
# Author: Nestor Coppi
# Nick: Shelvak
# URL: https:/github.com/Shelvak
# Image: https://dl.dropboxusercontent.com/u/58379025/Shelvak-theme.png

PROMPT='%{$fg_bold[green]%}%p %{$fg[green]%}%c%{$fg_bold[cyan]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
RPROMPT='%{$fg[blue]%}[%n » %D{%I:%M:%S}]%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}(%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[cyan]%}→%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%})%{$fg[yellow]%}🍺 %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%})"
