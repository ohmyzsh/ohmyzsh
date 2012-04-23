# Yay! High voltage and arrows!

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%} ("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[blue]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT='%{$fg[green]%}%1~%{$reset_color%}%{$fg[red]%}:$(git_prompt_info) %{$fg[cyan]%}->%{$reset_color%} '
