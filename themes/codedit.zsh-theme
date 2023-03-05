ZSH_THEME_GIT_PROMPT_PREFIX="git:"
ZSH_THEME_GIT_PROMPT_SUFFIX=";"
ZSH_THEME_GIT_PROMPT_DIRTY="%B#%b"
ZSH_THEME_GIT_PROMPT_CLEAN="*"

PROMPT='
%{$fg[blue]%}|%{$reset_color%} %B%{$fg[magenta]%}%n%{$reset_color%}%b@%B%{$fg[cyan]%}$(cat /etc/hostname)%{$reset_color%}%b %U%{$fg[yellow]%}%2/%{$reset_color%}%u %{$fg[green]%}$(git_prompt_info)%{$reset_color%}
%{$fg[blue]%}|%{$reset_color%} %S%t%s => '
RPROMPT='%(?.^_^.%B%{$fg[red]%}%?%f%b)'