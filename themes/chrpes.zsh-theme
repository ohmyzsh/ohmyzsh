ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[grey]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[grey]%}✗"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[grey]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[grey]%}✓"

#Customized git status, oh-my-zsh currently does not allow render dirty status before branch
git_custom_status() {
  local cb=$(current_branch)
  if [ -n "$cb" ]; then
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)%B$(parse_git_dirty)%b$ZSH_THEME_GIT_PROMPT_SUFFIX "
  fi
}

rvm_status() {
  if [[ -s ~/.rvm/scripts/rvm ]] ; then 
  	echo "%{$fg[grey]%}`~/.rvm/bin/rvm-prompt`%{$reset_color%}"
  fi
}

PROMPT='%{$fg[yellow]%}%~% %(?.%{$fg[green]%}.%{$fg[red]%})%B ➜ %b'
RPS1=' $(git_custom_status)$(rvm_status) $EPS1'
