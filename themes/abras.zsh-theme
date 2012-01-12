local rvm_prompt='%{$fg[yellow]%}$(rvm-prompt)%{$reset_color%}'
local current_path='%{$terminfo[bold]$fg[cyan]%} %~%{$reset_color%}'
local git_info='%{$fg_bold[white]%}$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="at %{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[magenta]%} ✗"
#ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✔"

#RPROMPT="%{$fg[white]%}%n@%{$fg[white]%}%m%{$reset_color%}"
PROMPT="${rvm_prompt} in${current_path} ${git_info} % %{$reset_color%}
%{$fg_bold[red]%}➜ %{$reset_color%}"

