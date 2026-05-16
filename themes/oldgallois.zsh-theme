# Depends on the git plugin for work_in_progress()
(( $+functions[work_in_progress] )) || work_in_progress() {}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Customized git status, oh-my-zsh currently does not allow render dirty status before branch
git_custom_status() {
  local branch=$(git_current_branch)
  [[ -n "$branch" ]] || return 0
  echo "$(parse_git_dirty)\
%{${fg_bold[yellow]}%}$(work_in_progress)%{$reset_color%}\
${ZSH_THEME_GIT_PROMPT_PREFIX}${branch}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

# RVM component of prompt
ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg[red]%}["
ZSH_THEME_RUBY_PROMPT_SUFFIX="]%{$reset_color%}"

# Combine it all into a final right-side prompt
RPS1="\$(git_custom_status)\$(ruby_prompt_info)${RPS1:+ $RPS1}"
PROMPT='%{$fg[cyan]%}[%~% ]%(?.%{$fg[green]%}.%{$fg[red]%})%B$%b '
