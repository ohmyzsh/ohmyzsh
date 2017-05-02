PROMPT=$'
%{$fg[green]%}${PWD/#$HOME/~}%{$reset_color%} %{$fg[white]%}[%n@%m]%{$reset_color%} %{$fg[white]%}[%T] $(git_prompt_info)%{$reset_color%}
%{$fg_bold[black]%}>%{$reset_color%} '
RPS1='%(?..%{$fg[magenta]%}%? ↵%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
