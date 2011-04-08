# ZSH Theme - Preview: http://img.skitch.com/20091113-qqtd3j8xinysujg5ugrsbr7x1y.jpg
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT='%{$fg[green]%}%m%{$reset_color%} %2~ $(vcs_prompt_info)%{$reset_color%}%B»%b '
RPS1="${return_code}"

ZSH_THEME_VCS_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_VCS_PROMPT_SUFFIX="› %{$reset_color%}"
