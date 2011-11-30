PROMPT='%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[blue]%}%m:%{$fg[green]%}%0~%{$fg[red]%}%(?.. [%?]) %{$reset_color%}%% '
RPROMPT='$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
