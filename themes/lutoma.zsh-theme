PROMPT=$'%{$reset_color%}%{$fg[cyan]%}%m %{$fg_bold[green]%}%c$(git_prompt_info) %(!.%{$fg_bold[red]%}#.%{$fg_bold[green]%}❯)%{$reset_color%} '
RPROMPT='%{$fg_bold[blue]%}[%*]%{$reset_color%}'
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[blue]%}git%{$reset_color%}:%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
