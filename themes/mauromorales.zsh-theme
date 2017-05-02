local user_host='%{$terminfo[bold]$fg[green]%}%n@%m%{$reset_color%}'

local original='%{$fg_bold[red]%} %{$fg_bold[green]%}%p %{$fg[cyan]%}%c'

local git_branch='%{$fg_bold[blue]%}$(git_prompt_info)%{$reset_color%}'
local svn_branch='%{$fg_bold[blue]%}$(svn_prompt_info)%{$reset_color%}'
local ruby_version=''

if which rvm-prompt &> /dev/null; then
  ruby_version='%{$fg[red]%}‹$(~/.rvm/bin/rvm-prompt i v)› %{$reset_color%}'
else
  if which rbenv &> /dev/null; then
    ruby_version='%{$fg[red]%}‹$(rbenv version | sed -e "s/ (set.*$//")› %{$reset_color%}'
  fi
fi

PROMPT="忍% ${user_host} ${original} ${ruby_version} ${git_branch} ${svn_branch}
者%B$%b "


ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})%{$fg[yellow]%} ✗ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}) "



ZSH_PROMPT_BASE_COLOR="%{$fg_bold[blue]%}"
ZSH_THEME_REPO_NAME_COLOR="%{$fg_bold[red]%}"

ZSH_THEME_SVN_PROMPT_PREFIX="svn:("
ZSH_THEME_SVN_PROMPT_SUFFIX=")"
ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[red]%} ✘ %{$reset_color%}"
ZSH_THEME_SVN_PROMPT_CLEAN=" "
