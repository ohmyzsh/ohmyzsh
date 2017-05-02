PROMPT=$'%{$fg[green]%}%n%{$reset_color%}@%m %{$fg_bold[magenta]%}%2~%{$reset_color%} $(git_prompt_info) (%{$fg[blue]%}%?%{$reset_color%})> '
RPROMPT='[%*]'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
