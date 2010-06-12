PROMPT=' %{$fg_bold[green]%}%2c %{$fg_bold[blue]%}%{[%}%{$reset_color%} '
RPROMPT='$(git_prompt_info) %{$fg[blue]%}] %{$fg[green]%}%D{%L:%M} %{$fg[yellow]%}%D{%p}%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
