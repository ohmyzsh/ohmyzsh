# -*-sh-*-
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
local current_dir='%{$terminfo[bold]$fg[green]%}%~%{$reset_color%}'
local rvm_ruby='%{$fg[red]%}$(rvm_prompt_info)%{$reset_color%}'
local git_branch='%{$fg[green]%}$(git_prompt_info)%{$reset_color%}'
local psql_version='PG %{$fg[blue]%}`psql --version | sed -e "s/[^.0-9]//g"`${reset_color%}'

PROMPT="[%h] %{$fg[blue]%}%n@%m:${rvm_ruby} ${psql_version} 
${git_branch} ${current_dir} %B$%b "

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"

zle_highlight=(region:standout special:standout suffix:bold isearch:bold,underline,fg=yellow,bg=red) 
