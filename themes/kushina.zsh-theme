# Based on robbyrussell's theme, with host and rvm indicators. Example:
# @host ➜ currentdir rvm:(rubyversion@gemset) git:(branchname)

# Get the current ruby version in use with RVM:
if [ -e ~/.rvm/bin/rvm-prompt ]; then
    RUBY_PROMPT_="%{$fg_bold[blue]%}rvm:(%{$fg[green]%}\$(~/.rvm/bin/rvm-prompt s i v g)%{$fg_bold[blue]%})%{$reset_color%} "
else
  if which rbenv &> /dev/null; then
    RUBY_PROMPT_="%{$fg_bold[blue]%}rbenv:(%{$fg[green]%}\$(rbenv version | sed -e 's/ (set.*$//')%{$fg_bold[blue]%})%{$reset_color%} "
  fi
fi

# Get the host name (first 4 chars)
HOST_PROMPT_="%{$fg_bold[red]%}@$HOST[0,8] at %{$fg_bold[cyan]%}%c "
GIT_PROMPT_="%{$fg_bold[blue]%}\$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}"
# http://stackoverflow.com/questions/3005963/how-can-i-have-a-newline-in-a-string-in-sh
STR=$'\n%{$fg_bold[red]%}➜ %{$reset_color%}'
LINE_PROMPT="$STR"
PROMPT="$HOST_PROMPT_$RUBY_PROMPT_$GIT_PROMPT_:$LINE_PROMPT"

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
