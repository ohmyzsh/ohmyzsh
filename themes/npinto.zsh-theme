if [ "`id -u`" -eq 0 ]; then
PROMPT="%{$fg_bold[cyan]%}%T%{$fg_bold[green]%} %{$fg_bold[red]%}%n%{$fg[yellow]%}@%{$fg_bold[white]%}%m %{$fg_bold[green]%}%~
%{$fg_bold[yellow]%}%% %{$reset_color%}"
else
PROMPT="%{$fg_bold[cyan]%}%T%{$fg_bold[green]%} %{$fg_bold[blue]%}%n%{$fg[yellow]%}@%{$fg_bold[white]%}%m %{$fg_bold[green]%}%~
%{$fg_bold[yellow]%}%% %{$reset_color%}"
fi
