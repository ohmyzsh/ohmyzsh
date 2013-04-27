ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[gray]%}:%{$reset_color%}%{$reset_color%}%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[yellow]%}>"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[yellow]%}<"
ZSH_THEME_GIT_PROMPT_DIVERGED="%{$fg[yellow]%}<>"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[red]%}*"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}-"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[red]%}="
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}!"

PROMPT='%{$fg[gray]%}#%{$reset_color%}%{$fg[blue]%}%n%{$reset_color%}%{$fg[gray]%}@%{$reset_color%}%{$fg[blue]%}%m%{$reset_color%}%{$fg[gray]%}:%{$reset_color%}%{$fg[white]%}%0~%{$reset_color%}$(git_prompt_info)$(git_prompt_status) %{$fg[cyan]%}
$%{$reset_color%} '
