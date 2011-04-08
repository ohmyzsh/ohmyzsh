PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(vcs_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

ZSH_THEME_VCS_PROMPT_PREFIX="("
ZSH_THEME_VCS_PROMPT_SUFFIX=")"
ZSH_THEME_VCS_PROMPT_DIRTY=""
ZSH_THEME_VCS_PROMPT_CLEAN=""

RPROMPT='$(vcs_prompt_status)%{$reset_color%}'

ZSH_THEME_VCS_PROMPT_ADDED="%{$fg[cyan]%} ✈"
ZSH_THEME_VCS_PROMPT_MODIFIED="%{$fg[yellow]%} ✭"
ZSH_THEME_VCS_PROMPT_DELETED="%{$fg[red]%} ✗"
ZSH_THEME_VCS_PROMPT_RENAMED="%{$fg[blue]%} ➦"
ZSH_THEME_VCS_PROMPT_UNMERGED="%{$fg[magenta]%} ✂"
ZSH_THEME_VCS_PROMPT_UNTRACKED="%{$fg[grey]%} ✱"
