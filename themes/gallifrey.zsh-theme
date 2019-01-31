# ZSH Theme - Preview: http://img.skitch.com/20091113-qqtd3j8xinysujg5ugrsbr7x1y.jpg
return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
host_color="%(!.%{$fg[red]%}.%{$fg[green]%})"

PROMPT="${host_color}%m%{$reset_color%} %2~ \$(git_prompt_info)%{$reset_color%}%B»%b "
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

unset return_code host_color
