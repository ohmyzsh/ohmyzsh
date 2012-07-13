PROMPT='%(?, %{$fg[cyan]%}, %{$fg[magenta]%})➜%{$reset_color%} %p %c $(git_prompt_info) '

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}%{$reset_color%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}%{$reset_color%})"
