local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

local user_host='%{$terminfo[bold]$fg[blue]%}@%m%{$reset_color%}'
local git_branch='$(git_prompt_info)%{$reset_color%}'
local current_dir='${PWD/#$HOME/~}'
local user_symbol=' ›'
local rvm_ruby=''

if which rvm-prompt &> /dev/null; then
  rvm_ruby='%{$fg[red]%}($(rvm-prompt i v g))%{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    rvm_ruby='%{$fg[red]%}($(rbenv version | sed -e "s/ (set.*$//"))%{$reset_color%}'
  fi
fi

PROMPT="${user_host} ${current_dir} ${git_branch}${rvm_ruby}%B${user_symbol}%b "
RPS1="%B${return_code}%b"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="] %{$reset_color%}"
