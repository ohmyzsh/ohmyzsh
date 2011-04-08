PROMPT='%{$fg_bold[red]%}%m%{$reset_color%}:%{$fg[cyan]%}%c%{$reset_color%}:%# '
RPROMPT='%{$fg_bold[green]%}$(vcs_prompt_info)%{$reset_color%}% '

ZSH_THEME_VCS_PROMPT_PREFIX="<%{$fg[red]%}"
ZSH_THEME_VCS_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_VCS_PROMPT_DIRTY="%{$fg[green]%} %{$fg[yellow]%}✗%{$fg[green]%}>%{$reset_color%}"
ZSH_THEME_VCS_PROMPT_CLEAN="%{$fg[green]%}>"
