function git_prompt_info_color() {
  local ref_color=""
  local git_status="$(parse_git_dirty)"
 if [[ -d  .git || $(git rev-parse --is-inside-work-tree 2>/dev/null) = true ]]; then
  if [[ -n $(git status -s) ]]; then
    ref_color="%F{yellow}"  # Green color for clean branch
  else
    ref_color="%F{green}" # Yellow color for dirty branch
  fi
 fi
  local ref
  ref=$(__git_prompt_git symbolic-ref --short HEAD 2> /dev/null) \
    || ref=$(__git_prompt_git describe --tags --exact-match HEAD 2> /dev/null) \
    || ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) \
    || return 0

  local upstream
  if (( ${+ZSH_THEME_GIT_SHOW_UPSTREAM} )); then
    upstream=$(__git_prompt_git rev-parse --abbrev-ref --symbolic-full-name "@{upstream}" 2>/dev/null) \
    && upstream=" -> ${upstream}"
  fi

  echo "%F{cyan}${ZSH_THEME_GIT_PROMPT_PREFIX}${ref_color}${ref:gs/%/%%}%F{cyan}${upstream:gs/%/%%}${git_status}%f%F{cyan}${ZSH_THEME_GIT_PROMPT_SUFFIX}%f"
}

alias git_prompt_info='git_prompt_info_color'





PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
