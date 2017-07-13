local user_class="%(!.#.$)"
local ret_status="%(?:%{$fg_bold[green]%}${user_class}:%{$fg_bold[red]%}${user_class})"
PROMPT='%{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)${ret_status}%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
