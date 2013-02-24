#clarkbarz theme

PROMPT='%{$fg[white]%}%n%{$reset_color%}%{$fg[yellow]%}λ%{$fg[white]%}%M%{$reset_color%}%{$fg[yellow]%} (%{$fg[white]%}${PWD/#$HOME/~}%{$reset_color%}%{$fg[yellow]%})$(git_prompt_info)
└> % %{$reset_color%}'
RPROMPT='%{$fg[yellow]%}[%{$fg[white]%}%*%{$fg[yellow]%}]%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" (%{$reset_color%}%{$fg[white]%}git:%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg[yellow]%})"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
