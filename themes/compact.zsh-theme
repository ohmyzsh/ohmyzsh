PROMPT=$'%{$fg_bold[green]%}%n@%m%{$reset_color%}:%{$fg_bold[blue]%}%D{%I.%M.%S}%{$reset_color%}:%{$fg[white]%}%1~%{$reset_color%}$(git_prompt_info)%(?..%{$fg_bold[red]%}X%{$reset_color%})%{$fg[blue]%}> %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
