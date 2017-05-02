ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$reset_color%}%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$reset_color%}%{$fg[yellow]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$reset_color%}(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}+%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}-%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[red]%}>%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[red]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}?%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}*%{$reset_color%}"

function is_git_repo() {
  local cb=$(current_branch)
  if [ -n "$cb" ]; then
    return 0
  else
    return 1
  fi
}

function git_custom_info() {
  local git_info=""
  git_info+="$ZSH_THEME_GIT_PROMPT_PREFIX"
  git_info+="$(current_branch)"
  git_info+="$(git_prompt_short_sha)"
  git_info+="$ZSH_THEME_GIT_PROMPT_SUFFIX"

  echo "$git_info"
}

function git_custom_status() {
  local git_status=""
  git_status+="%{$reset_color%} "
  git_status+="$(parse_git_dirty)"

  local statuses=$(git_prompt_status)
  if [ -n "$statuses" ]; then
    git_status+="%{$reset_color%}"
    git_status+=" $statuses"
    git_status+="%{$reset_color%}"
  fi
  git_status+="%{$reset_color%}"

  echo "$git_status"
}

function serenity() {
  local serenity_prompt=""
  serenity_prompt='%m: %2~'

  if is_git_repo; then
    serenity_prompt+="$(git_custom_info)"
    serenity_prompt+="$(git_custom_status)"
  fi

  serenity_prompt+='\n'
  serenity_prompt+='%# '

  echo "$serenity_prompt"
}


PROMPT='$(serenity)'

# vim:set ft=zsh:
