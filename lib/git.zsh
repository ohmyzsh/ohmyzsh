# get the name of the branch we are on
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

parse_git_dirty () {
  gitstat=$(git status -s 2>/dev/null | grep -v '\(^A|^M|^.M|??\)')

  if [[ $(echo ${gitstat} | grep -v '^$' | wc -l | tr -d ' ') == 0 ]]; then
	echo -n "$ZSH_THEME_GIT_PROMPT_CLEAN"
	else
	echo -n "$ZSH_THEME_GIT_PROMPT_UNCLEAN_SPACER"
  fi

  if [[ $(echo ${gitstat} | grep -c "^.[MD]") > 0 ]]; then
	echo -n "$ZSH_THEME_GIT_PROMPT_DIRTY"
  fi

  if [[ $(echo ${gitstat} | grep -c "^[MAD]") > 0 ]]; then
	echo -n "$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  if [[ $(echo ${gitstat} | grep -c '^??') > 0 ]]; then
	echo -n "$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi
}
