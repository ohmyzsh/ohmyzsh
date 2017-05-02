if [ $UID -eq 0 ]; then CARETCOLOR="red"; else CARETCOLOR="white"; fi

local return_code="%(?..%{$fg[red]%}[#%?]%{$reset_color%})"

PS1='%{$reset_color%}%6~$(git_prompt_info)%{${fg[$CARETCOLOR]}%}${return_code}$%{${reset_color}%} '

RPS1='[%*]'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}@"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}‡ "
