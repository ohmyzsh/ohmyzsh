PROMPT='$(git_prompt_info)%{$fg[red]%} %(?,★,☆)  %{$reset_color%}'
RPROMPT='%{$fg[red]%}%n%{$reset_color%} on %{$fg[red]%}%m%{$reset_color%} in %{$fg[red]%}%~%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="❮%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}❯"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[magenta]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
