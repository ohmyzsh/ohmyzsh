# get the name of the branch we are on

VCS+="git"

function git_check() {
    git status -s > /dev/null 2>&1
    return $?
}

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "${(e)ZSH_THEME_VCS_PROMPT_PREFIX}${ref#refs/heads/}$(parse_git_dirty)${ZSH_THEME_VCS_PROMPT_SUFFIX}"
}

parse_git_dirty () {
  if [[ -n $(git status -s 2> /dev/null) ]]; then
    echo "$ZSH_THEME_VCS_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_VCS_PROMPT_CLEAN"
  fi
}

# get the status of the working tree
git_prompt_status() {
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$ZSH_THEME_VCS_PROMPT_UNTRACKED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
    STATUS="$ZSH_THEME_VCS_PROMPT_ADDED$STATUS"
  elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
    STATUS="$ZSH_THEME_VCS_PROMPT_ADDED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
    STATUS="$ZSH_THEME_VCS_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
    STATUS="$ZSH_THEME_VCS_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
    STATUS="$ZSH_THEME_VCS_PROMPT_MODIFIED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
    STATUS="$ZSH_THEME_VCS_PROMPT_RENAMED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
    STATUS="$ZSH_THEME_VCS_PROMPT_DELETED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    STATUS="$ZSH_THEME_VCS_PROMPT_UNMERGED$STATUS"
  fi
  echo $STATUS
}
