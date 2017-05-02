PROMPT='%{$fg[cyan]%}%D @ %T %{$fg[magenta]%}%m%{$reset_color%}:%{$fg_bold[yellow]%}%c %{$fg_bold[magenta]%}%n%{$reset_color%}% %{$fg_bold[cyan]%}$%{$reset_color%}%  '
RPROMPT='%{$fg_bold[cyan]%}$(git_prompt_info)%{$reset_color%}% '

ZSH_THEME_GIT_PROMPT_PREFIX="|%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[cyan]%} %{$fg[yellow]%}✗%{$fg[cyan]%}>%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}>"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}%B✘ %b%{$fg_bold[cyan]%}|%f%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔ %b%{$fg_bold[cyan]%}|%f%{$reset_color%}"
