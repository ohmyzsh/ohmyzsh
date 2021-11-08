if [ "$USERNAME" = "root" ]; then CARETCOLOR="red"; else CARETCOLOR="blue"; fi

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT='%{$fg[green]%}[%D{%H:%M:%S}]%{$reset_color%} %{$fg_no_bold[cyan]%}%n %{${fg_bold[blue]}%}::%{$reset_color%} %{$fg[yellow]%}%m%{$reset_color%} %{$fg_no_bold[magenta]%} ➜ %{$reset_color%} %{${fg[green]}%}%3~ $(git_prompt_info)%{${fg_bold[$CARETCOLOR]}%}»%{${reset_color}%} '

RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
