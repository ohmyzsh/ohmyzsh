if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="magenta"; fi

local ret_status="%(?..%{$fg_bold[yellow]$bg_bold[red]%}{%?}%{$reset_color%})"

PROMPT='%{${ret_status}$fg_bold[$NCOLOR]%n$reset_color@$fg_bold[yellow]%m:$fg_bold[blue]%~%}
%{$fg_bold[yellow]%}➤ %{$reset_color%}'
RPROMPT='%{$fg[yellow]%}%p $(git_prompt_info)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="]"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""
