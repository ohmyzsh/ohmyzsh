if [ "$(whoami)" = "root" ]; then ROOTCOLOR="red"; else ROOTCOLOR="green"; fi

local return_code="%(?..%{$fg[red]%}%? <-'%{$reset_color%})"

PROMPT='%(?.%{$fg_bold[white]%}.%{$fg[red]%})[%*]%{$reset_color%} %{$fg[blue]%}%! %{${fg_no_bold[$ROOTCOLOR]}%}%n%{${fg_bold[blue]}%}@%{$reset_color%}%{$fg[yellow]%}%m%{$reset_color%}:%{${fg[cyan]}%}%5~ $(git_prompt_info)%{${fg[$ROOTCOLOR]}%}>>%{${reset_color}%} '

RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=" %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}[%{$fg_bold[green]%}✓%{$fg[blue]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}[%{$fg[red]%}✗%{$fg[blue]%}]%{$reset_color%}"

