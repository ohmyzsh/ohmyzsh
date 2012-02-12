(( EUID == 0 )) && ucolor=red || ucolor=cyan
[[ -n $SSH_TTY ]] && hostcolor=yellow || hostcolor=blue

PROMPT='%{$fg[$ucolor]%}%n%{$reset_color%}@%{$fg[$hostcolor]%}%m%{$reset_color%}: %{$fg[green]%}%0~%{$fg[red]%}%(?.. [%?]) %{$reset_color%}%% '
RPROMPT='$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
