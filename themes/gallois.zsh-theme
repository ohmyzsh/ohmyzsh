ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

#Customized git status, oh-my-zsh currently does not allow render dirty status before branch
git_custom_status() {
  local cb=$(current_branch)
  if [ -n "$cb" ]; then
    echo "$(parse_git_dirty)%{$fg_bold[yellow]%}$(work_in_progress)%{$reset_color%}$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

function gallois_virtualenv_info {
  [ $VIRTUAL_ENV ] && echo "[`basename $VIRTUAL_ENV`]"
}

function gallois_ruby_info {
  if [[ -s ~/.rvm/scripts/rvm ]] ; then
    echo "[`~/.rvm/bin/rvm-prompt`]"
  elif which rbenv &> /dev/null; then 
    echo "[`rbenv version | sed -e "s/ (set.*$//"`]"
  fi
}

RPS1='$(git_custom_status)%{$fg[red]%}`gallois_ruby_info`%{$fg[yellow]%}`gallois_virtualenv_info`%{$reset_color%} $EPS1'

PROMPT='%{$fg[cyan]%}[%~% ]%(?.%{$fg[green]%}.%{$fg[red]%})%B$%b '
