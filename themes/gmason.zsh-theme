local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

local userhostcolor='green'

local time='%{$fg_bold[cyan]%}%T%{$reset_color%}'
local user_host='%{$terminfo[bold]$fg[$userhostcolor]%}%n%{$fg[magenta]%}@$reset_color$fg[$userhostcolor]%}%m%'
local current_dir='%{$terminfo[bold]$fg[blue]%} %~%{$reset_color%}'
local git_branch='$(git_prompt_info)%{$reset_color%}'

PROMPT="${time} ${user_host} ${current_dir} ${git_branch}
%{$fg_bold[yellow]%}%B$%b %{$reset_color%}"
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
