PROMPT='%n%{$reset_color%}%{$fg[red]%}@%m%{$reset_color%}:[%{$fg[green]%}%~%{$reset_color%}]$(git_prompt_info)%{$fg[red]%} ➜  %{$reset_color%}'
RPROMPT='[%{$fg[red]%}%W %t%{$reset_color%}]'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%} <"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=":%{$fg[red]%}✗%{$fg[red]%}>%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}>"
