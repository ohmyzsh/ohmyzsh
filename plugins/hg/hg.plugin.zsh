# get the name of the branch we are on

VCS+="hg"

function hg_check() {
    hg status -n > /dev/null 2>&1
    return $?
}

function hg_prompt_info() {
  ref=$(hg branch 2> /dev/null) || return
  echo "${(e)ZSH_THEME_VCS_PROMPT_PREFIX}${ref}$(parse_hg_dirty)$ZSH_THEME_VCS_PROMPT_SUFFIX"
}

parse_hg_dirty () {
  if [[ -n $(hg status -s 2> /dev/null) ]]; then
    echo "$ZSH_THEME_VCS_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_VCS_PROMPT_CLEAN"
  fi
}

# get the status of the working tree
hg_prompt_status() {
  INDEX=$(hg status 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | grep '^? ' &> /dev/null); then
    STATUS="$ZSH_THEME_VCS_PROMPT_UNTRACKED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
    STATUS="$ZSH_THEME_VCS_PROMPT_ADDED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^M ' &> /dev/null); then
    STATUS="$ZSH_THEME_VCS_PROMPT_MODIFIED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^R ' &> /dev/null); then
    STATUS="$ZSH_THEME_VCS_PROMPT_DELETED$STATUS"
  fi
  echo $STATUS
}
