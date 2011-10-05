PROMPT='(%{$fg_bold[magenta]%}%n%{$reset_color%}@%{$fg_bold[blue]%}%m%{$reset_color%}) - (%{$fg_bold[blue]%}%T%{$reset_color%}) - (%{$fg_bold[blue]%}%~%{$reset_color%}%)
$(git_prompt_info)%{$reset_color%}$fg_bold[green]%}➜ %{$reset_color%}%{$fg_bold[green]%'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:%{$reset_color%}(%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}) %{$fg_bold[red]%}✗%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}) "
