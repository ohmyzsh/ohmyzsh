local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )%{$reset_color%}"
local machine="%(!:%{$fg_bold[magenta]%}%m:%{$fg_bold[yellow]%}%m)%{$reset_color%}"
local final_prompt="%(!:%{$fg_bold[red]%}:%{$fg_bold[green]%})%#%{$reset_color%}"
PROMPT='${ret_status} ${machine} %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)${final_prompt} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
