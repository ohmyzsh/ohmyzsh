local user="$(whoami)"

if [ "$user" = "root" ]; then 
    PROMPT="%{$fg[cyan]%}[%{$fg[yellow]%}_ROOT_%{$reset_color%}@%{$fg[red]%}$(~/scripts/shorthost) %{$fg[yellow]%}%~%{$fg[cyan]%}]%{$fg[red]%}%%%{$reset_color%} "
elif [ "$user" = "komitee" ] || [ "$user" = "mkomitee" ]; then
    PROMPT="%{$fg[cyan]%}[%{$fg[red]%}%{$fg[yellow]%}@%{$fg[magenta]%}$(~/scripts/shorthost) %{$fg[yellow]%}%~%{$fg[cyan]%}]%{$reset_color%}%% "
else 
    PROMPT="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}$(~/scripts/shorthost) %{$fg[yellow]%}%~ %{$reset_color%}%% "
    PROMPT="%{$fg[cyan]%}[%{$fg[yellow]%}%n%{$fg[blue]%}@%{$fg[magenta]%}$(~/scripts/shorthost) %{$fg[yellow]%}%~%{$fg[cyan]%}]%{$fg[green]%}%%%{$reset_color%} "
fi

