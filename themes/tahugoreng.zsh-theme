local box='%{$fg_bold[red]%}▬ '
local name='%{$fg_bold[cyan]%}%n'
local on='%{$fg_bold[white]%}on'
local c='%{$fg_bold[blue]%}%c'
local git_branch='%{$fg_bold[white]%}$(git_prompt_info)'

PROMPT="${box} ${on} ${c} ${git_branch} 
${box} %{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="git@%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[white]% status: %{$fg[red]%}UNTRACKED FILES%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg_bold[white]% status: %{$fg[green]%}☻ %{$fg_bold[white]%}"
