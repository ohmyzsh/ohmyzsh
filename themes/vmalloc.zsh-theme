PROMPT='%(?.%{$fg_bold[green]%}.%{$fg_bold[red]%})➜ %{$fg_bold[green]%}%p %{$fg[white]%}%c %{$fg_bold[black]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[black]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[black]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[black]%})"

