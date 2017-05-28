if [ "$USER" = "root" ]; then CARETCOLOR="red"; else CARETCOLOR="blue"; fi

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT='%{$fg[green]%}[%*]%{$reset_color%} %{$fg_no_bold[cyan]%}%n %{${fg_bold[blue]}%}::%{$reset_color%} %{$fg[yellow]%}%m%{$reset_color%} %{$fg_no_bold[magenta]%} ➜ %{$reset_color%} %{${fg[green]}%}%3~ %{${fg_bold[$CARETCOLOR]}%}»%{${reset_color}%} '

RPS1="${return_code}"
