local rvm_ruby='%{$fg[white]%}[%{$fg[green]%}$(~/.rvm/bin/rvm-prompt)%{$fg[white]%}]%{$reset_color%}'
local user_at_host='%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}'
local current_dir='%{$fg[green]%}${PWD/#$HOME/~}%{$reset_color%}'
local git_prompt='%{$fg[cyan]%} $(git_prompt_info)%{$reset_color%}'

PROMPT="${user_at_host}${rvm_ruby}:${current_dir}${git_prompt} %(!.#.$) "

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[cyan]%}git:("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"

