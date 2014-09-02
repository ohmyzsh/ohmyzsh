local ret_status="%(?::%{$fg_bold[red]%}%s)(%?)%{$reset_color%}"
PROMPT='${ret_status} %{$fg_bold[green]%}%n@%m %{$fg_bold[blue]%}[%3~]%{$reset_color%} %# '
RPS1='$(git_prompt_info) %{$reset_color%}%T'
PS2='%{$fg_bold[blue]%}[%3~]%{$reset_color%} > '
RPS2='< %{$fg_bold[green]%}%_%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}|%{$fg_bold[yellow]%}?%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}|%{$fg_bold[green]%}c%{$reset_color%})"
