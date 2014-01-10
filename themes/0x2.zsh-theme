PROMPT='%{$fg[grey]%}%\[%{$reset_color%}%*%{$fg[grey]%}%\]$(git_prompt_info) %{$fg[cyan]%}%~ %{$fg[green]%}% $ % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
