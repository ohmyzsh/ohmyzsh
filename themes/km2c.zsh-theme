# Based on robbyrussell's theme, with host and rvm indicators. Example:
# @host ➜ currentdir rvm:(rubyversion@gemset) git:(branchname)
# Get the current ruby version in use with RVM:
if [ -e ~/.rvm/bin/rvm-prompt ]; then
    RUBY_PROMPT="%{$FG[117]%}rvm:(%{%{$reset_color%}$FG[208]%}\$(~/.rvm/bin/rvm-prompt s i v g)%{$FG[117]%})%{$reset_color%} "
else
  if which rbenv &> /dev/null; then
    RUBY_PROMPT="%{$FG[117]%}rbenv:(%{$reset_color%}%{$FG[208]%}\$(rbenv version | sed -e 's/ (set.*$//')%{$FG[117]%})%{$reset_color%} "
  fi
fi

export SMILEY_HAPPY_FACE="☺ "
export SMILEY_SAD_FACE="☹ "
smiley_face() {
  print "%(?:%{$FG[118]%}%B${SMILEY_HAPPY_FACE}%b:%{$FG[001]%}%B${SMILEY_SAD_FACE}%b)"
}

SMILEY_="$(smiley_face)"
DIR_PROMPT_="%{$FG[002]%} %1~ % "
GIT_PROMPT="%{$FG[117]%}\$(git_prompt_info)%{$reset_color%}\$(git_prompt_status)%{$reset_color%}%{$FG[117]%}%{$FG[208]%}» %{$reset_color%}"

PROMPT="$SMILEY_$DIR_PROMPT_$GIT_PROMPT"
RPROMPT="$RUBY_PROMPT"

#Git prompt info
ZSH_THEME_GIT_PROMPT_PREFIX="%B%F{208}| %{$reset_color%}%{$FG[117]%}git:(%{$FG[118]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$FG[001]%}✗%{$reset_color%}%{$FG[117]%} )"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$FG[117]%} )"
#Git prompt status
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹ "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜ "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭ "
