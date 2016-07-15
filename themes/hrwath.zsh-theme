# hrwath prompt

PROMPT='%{$fg[yellow]%}${PWD/#$HOME/~}%{$fg[green]%}$(__git_ps1 "(%s)")%{$reset_color%} %{$fg_bold[blue]%}$ %{$reset_color%}'
