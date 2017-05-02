# ZSH Theme - Preview: http://i.min.us/iPtBLbLWy7yxx.png
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

local dtime='%{$fg[yellow]%}%T%{$reset_color%}'
local user_host='%{$fg[green]%}%n@%{$fg[cyan]%}%m%{$reset_color%}'
local current_dir='%{$terminfo[bold]$fg[blue]%}%~%{$reset_color%}'
local rvm_ruby='%{$fg[red]$terminfo[bold]%}$(rvm-prompt i v g)%{$reset_color%}'
local git_branch='$(git_prompt_info)%{$reset_color%}'
local arrow='%{$terminfo[bold]%}▶%{$reset_color%}'

PROMPT="${dtime} ${user_host}:${current_dir} ${rvm_ruby} ${git_branch}
  $arrow   %{$terminfo[bold]$fg[green]%}%%%b%{$reset_color%} "
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_CLEAN=" $fg[green]✓"
ZSH_THEME_GIT_PROMPT_DIRTY=" $fg[red]✗"
