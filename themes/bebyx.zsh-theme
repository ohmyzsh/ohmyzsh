# bebyx.zsh-theme (classic bash improved)

local user_host="%{$fg_bold[green]%}%n@%m:%{$reset_color%}"
local path_p="%{$fg_bold[blue]%}%~%{$reset_color%}"
local cmd_sign="%{$reset_color%}%{$fg[magenta]%}$%{$reset_color%}"
PROMPT='${user_host}${path_p}${cmd_sign} '
RPROMPT='%{$fg_bold[cyan]%}$(git_prompt_info)%{$fg_bold[cyan]%}%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="±(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[cyan]%}) %{$fg[red]%}✗%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[cyan]%}) "
