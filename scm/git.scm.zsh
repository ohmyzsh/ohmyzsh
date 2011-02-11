function scm_in_git_repo () {
    if [ "$(git st 2>/dev/null)" ]; then
        echo 1
    fi
}

function scm_git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  out="$ZSH_THEME_SCM_PROMPT_PREFIX${ref#refs/heads/}$(scm_parse_git_dirty)$ZSH_THEME_SCM_PROMPT_SUFFIX"
  if [[ ZSH_THEME_SCM_DISPLAY_NAME -eq 1 ]]; then
        out="git$out"
  fi
  echo $out
}

scm_parse_git_dirty () {
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    echo "$ZSH_THEME_SCM_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_SCM_PROMPT_CLEAN"
  fi
}
