ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""


#Customized git status, oh-my-zsh currently does not allow render dirty status before branch
git_custom_status() {
  local cb=$(current_branch)
  if [ -n "$cb" ]; then
    R="$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX$(git_prompt_rebase_state)"
    CI=$(git_changes_info)
    if [ ! -z $CI ]; then
      R="$CI $R"
    fi
    echo $R
  fi
}

#RVM and git settings
if [[ -s ~/.rvm/scripts/rvm ]] ; then
  RPS1='$(git_custom_status)%{$fg[red]%}[`~/.rvm/bin/rvm-prompt`]%{$reset_color%} $EPS1'
else
  if which rbenv &> /dev/null; then
    RPS1='$(git_custom_status)%{$fg[red]%}[`rbenv version | sed -e "s/ (set.*$//"`]%{$reset_color%} $EPS1'
  else
    RPS1='$(git_custom_status) $EPS1'
  fi
fi

RPS1="$RPS1%D{%I:%M:%S} "

PROMPT='%{$fg[cyan]%}[%{$fg[yellow]%}%n%{$fg[cyan]%}@%{$fg[yellow]%}%m%{$fg[cyan]%}:%{$fg[magenta]%}%~% %{$fg[cyan]%}]%(?.%{$fg[green]%}.%{$fg[red]%})%B$%b '
