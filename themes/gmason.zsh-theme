local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

local userhostcolor='green'

local time='%{$fg[cyan]%}%T%{$reset_color%}'
local user_host='%{$fg_bold[$userhostcolor]%}%n%{$fg[magenta]%}@%{$reset_color$fg_bold[$userhostcolor]%}%m%{$reset_color%}'
local current_dir='%{$fg[blue]%}%~%{$reset_color%}'
local git_branch='$(git_prompt_info)%{$reset_color%}'

PROMPT="${time} ${user_host} ${current_dir} ${git_branch}
%{$fg_bold[yellow]%}%B$%b %{$reset_color%}"
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
