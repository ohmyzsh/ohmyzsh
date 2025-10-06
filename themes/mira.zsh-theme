# Based on bira zsh theme with nvm, rvm and jenv support
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

local user_host='%{$terminfo[bold]$fg[green]%}%n@%m%{$reset_color%}'
local current_dir='%{$terminfo[bold]$fg[blue]%} %~%{$reset_color%}'

local nvm_node='%{$fg[green]%}‹node-$(nvm_prompt_info)›%{$reset_color%}'

local jenv_java='%{$fg[blue]%}‹$(jenv_prompt_info)›%{$reset_color%}'

local git_branch='$(git_prompt_info)'

local rvm_ruby='$(ruby_prompt_info)'

PROMPT="╭─${user_host} ${current_dir} ${nvm_node} ${rvm_ruby} ${jenv_java} ${git_branch}
╰─%B$%b "
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=") %{$reset_color%}"

ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg[red]%}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"
