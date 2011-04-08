# Comment

PROMPT='%{$fg[magenta]%}[%c] %{$reset_color%}'

RPROMPT='%{$fg[magenta]%}$(vcs_prompt_info)%{$reset_color%} $(vcs_prompt_status)%{$reset_color%}'

ZSH_THEME_VCS_PROMPT_PREFIX=""
ZSH_THEME_VCS_PROMPT_SUFFIX=""
ZSH_THEME_VCS_PROMPT_DIRTY=""
ZSH_THEME_VCS_PROMPT_CLEAN=""
ZSH_THEME_VCS_PROMPT_ADDED="%{$fg[cyan]%} ✈"
ZSH_THEME_VCS_PROMPT_MODIFIED="%{$fg[yellow]%} ✭"
ZSH_THEME_VCS_PROMPT_DELETED="%{$fg[red]%} ✗"
ZSH_THEME_VCS_PROMPT_RENAMED="%{$fg[blue]%} ➦"
ZSH_THEME_VCS_PROMPT_UNMERGED="%{$fg[magenta]%} ✂"
ZSH_THEME_VCS_PROMPT_UNTRACKED="%{$fg[grey]%} ✱"
