PROMPT='$(git_prompt_info)%{$fg[red]%} %(?,★,☆)  %{$reset_color%}'
RPROMPT='%{$fg[blue]%}%~%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
