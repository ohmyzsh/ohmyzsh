local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"
PROMPT='$bg_bold[black]$fg[white]%n$fg_bold[green]@$fg[white]%m$reset_color $fg_bold[cyan]${PWD/#$HOME/~} $fg[green]$bg[black]$(git_prompt_info)$reset_color
${ret_status}$reset_color'

ZSH_THEME_GIT_PROMPT_PREFIX="[git: "
ZSH_THEME_GIT_PROMPT_SUFFIX="]"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]+$fg[green]"
ZSH_THEME_GIT_PROMPT_UNTRACKED="$fg[red]?$fg[green]"
ZSH_THEME_GIT_PROMPT_CLEAN=""
