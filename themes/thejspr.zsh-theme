# get ruby version from either rvm or system ruby.
if [[ -s ~/.rvm/scripts/rvm ]] ; then
  RPS1="%{%}%{$reset_color%}%{$fg[red]%}\$(~/.rvm/bin/rvm-prompt i v g)%{$reset_color%}"
else
  RPS1="%{$fg[red]%}\$(ruby -e 'print RUBY_VERSION')%{$reset_color%} $EPS1"
fi

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]"

local host_name='%{$fg[white]%}%m%{$reset_color%}:'
local current_dir='%{$fg[blue]%}%~%{$reset_color%}'
local git_branch='$(git_prompt_info)'
local end_symbol=' %{$fg[white]%}%B$%b ' 

PROMPT="${host_name}${current_dir}${git_branch}${end_symbol}"
