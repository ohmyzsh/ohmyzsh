# Sparkles theme

PROMPT='%{$fg[magenta]%}[%c] %{$reset_color%} %{$fg[green]%}$(git_prompt_info)%{$reset_color%} $(git_prompt_status)%{$reset_color%} > '

# ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_PREFIX="\uebdb "
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} ^"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[white]%} *"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} x"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} ->"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} xx"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%} ?"
