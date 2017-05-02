PROMPT='%{$fg_bold[red]%}☠ % %m%{$reset_color%}:%{$fg[cyan]%}%c%  $ %{$reset_color%}'
RPROMPT='%{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}% '

ZSH_THEME_GIT_PROMPT_PREFIX="|%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} %{$fg[yellow]%}✗%{$fg[red]%}|%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✔ %{$fg[red]%}|"
RPROMPT='%{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}%'
