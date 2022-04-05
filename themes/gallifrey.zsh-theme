<<<<<<< HEAD
# ZSH Theme - Preview: http://img.skitch.com/20091113-qqtd3j8xinysujg5ugrsbr7x1y.jpg
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT='%{$fg[green]%}%m%{$reset_color%} %2~ $(git_prompt_info)%{$reset_color%}%B»%b '
=======
# ZSH Theme - Preview: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes#gallifrey
return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
host_color="%(!.%{$fg[red]%}.%{$fg[green]%})"

PROMPT="${host_color}%m%{$reset_color%} %2~ \$(git_prompt_info)%{$reset_color%}%B»%b "
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
<<<<<<< HEAD
=======

unset return_code host_color
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
