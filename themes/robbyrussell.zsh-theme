local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(kubectl_prompt_info)$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="🐐:%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

ZSH_THEME_KUBECTL_PROMPT_PREFIX="☁️ :%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_KUBECTL_PROMPT_SUFFIX="%{$fg[blue]%})%{$reset_color%} "
