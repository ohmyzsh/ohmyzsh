# This is a fork of gallois theme
# Now it can show both git and hg branches
# rvm is not shown
# You should use git & mercurial plugins

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Customized git status
function git_custom_status {
  local cb=$(current_branch)
  if [ -n "$cb" ]; then
    echo "$(parse_git_dirty)${ZSH_THEME_GIT_PROMPT_PREFIX}git:$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

# Customized hg status
function hg_custom_status {
  local cb=$(hg_current_branch)
  if [ -n "$cb" ]; then
    echo "$(parse_hg_dirty)${ZSH_THEME_GIT_PROMPT_PREFIX}hg:$(hg_current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

RPROMPT='$(git_custom_status)$(hg_custom_status)%{$reset_color%}'

PROMPT='%{$fg[cyan]%}[%~% ]%(?.%{$fg[green]%}.%{$fg[red]%})%B$%b '