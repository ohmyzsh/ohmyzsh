local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ %s)"
local user_host="%{$fg_bold[black]%}[%{$reset_color%} %{$fg_bold[yellow]%}%n%{$reset_color%} %{$fg_bold[black]%}]%{$reset_color%}"
local current_dir="%{$fg_bold[black]%}[%{$reset_color%} %{$fg_bold[green]%} %~ %{$reset_color%} %{$fg_bold[black]%}]%{$reset_color%}"
local current_time="%{$fg_bold[black]%}[%{$reset_color%} %{$fg_bold[red]%}%D %*%{$reset_color%} %{$fg_bold[black]%}]%{$reset_color%}"

PROMPT='${user_host} ${current_dir} ${current_time} ${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} %{$reset_color%}'

alias ls="ls -G"

export SUDO_PS1="\[\e[1;30m\]\[[\e[\e[1;30m\]\e[1;33m\] \u \[\e[1;30m\]\[]\] \[\e[1;30m\]\[[\] \[\e[1;32m\]\w\[\e[0m\] \[\e[1;30m\]\[]\]\[[\[ \[\e[1;31m\]\t\[\e[0m\] \[\e[1;30m\]\[]\] \[$\] \[\e[37m\]"

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
