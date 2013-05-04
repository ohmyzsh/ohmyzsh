# Based on nebirhos' theme:
# (i) Simple prompt to tell a shell from a JHBuild one (adds [JHB] after host, see below);
# (ii)Full hostname.
# @host[JHB] ➜ currentdir rvm:(rubyversion@gemset) git:(branchname)

# Get the current ruby version in use with RVM:
if [ -e ~/.rvm/bin/rvm-prompt ]; then
    RUBY_PROMPT_="%{$fg_bold[blue]%}rvm:(%{$fg[green]%}\$(~/.rvm/bin/rvm-prompt s i v g)%{$fg_bold[blue]%})%{$reset_color%} "
else
  if which rbenv &> /dev/null; then
    RUBY_PROMPT_="%{$fg_bold[blue]%}rbenv:(%{$fg[green]%}\$(rbenv version | sed -e 's/ (set.*$//')%{$fg_bold[blue]%})%{$reset_color%} "
  fi
fi

# Check if /opt/gnome/bin is in your path
# WARNING if you configured jhbuild to put files in /path/to/jhbuild'd/gnome
# you should change /opt/gnome/bin to /path/to/jhbuild'd/gnome
if [[ $PATH == */opt/gnome/bin:* ]]; then
   JHBUILD_PROMPT="%{$fg_bold[blue]%}[%{$fg_bold[green]%}JHB%{$fg_bold[blue]%}]%{$fg_bold[red]%}"
fi

# Get the host name (first 4 chars)
HOST_PROMPT_="%{$fg_bold[red]%}$HOST$JHBUILD_PROMPT ➜  %{$fg_bold[cyan]%}%c "
GIT_PROMPT="%{$fg_bold[blue]%}\$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}"
PROMPT="$HOST_PROMPT_$RUBY_PROMPT_$GIT_PROMPT"

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"