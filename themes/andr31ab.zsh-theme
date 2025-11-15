PROMPT='%(!.%{$fg_bold[red]%} .%{$fg_bold[green]%} ) '
PROMPT+='%{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)'
PROMPT+=$'\n→ '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}) "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
