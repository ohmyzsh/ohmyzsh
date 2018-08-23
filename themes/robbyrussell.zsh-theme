PROMPT_SYMBOL=${ZSH_THEME_PROMPT_SYMBOL:-➜}

local ret_status="%(?:%{$fg_bold[green]%}${PROMPT_SYMBOL} :%{$fg_bold[red]%}${PROMPT_SYMBOL} )"
PROMPT='${ret_status} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
