cm="cm" # executable or path to plastic scm console binary

# aliases
alias cms="$cm status"

function plasticscm_get_branch_name() {
  _SELECTOR=`$cm showselector 2>/dev/null`
  if [ ! -z $_SELECTOR ]; then
    branch=`echo $_SELECTOR | sed -n -e 's/.*smartbranch //p' | tr -d '"' | tr -d ' ' | tr -d '\n' | tr -d '\r'`
    echo $branch
    unset branch
  fi
  unset _SELECTOR
}

function plasticscm_prompt_info {
  branch=`plasticscm_get_branch_name`
  if [ ! -z "$branch" ]; then
    echo "$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_PLASTICSCM_PROMPT_PREFIX $ZSH_THEME_REPO_NAME_COLOR$_DISPLAY$ZSH_PROMPT_BASE_COLOR$ZSH_PROMPT_BASE_COLOR$branch$(plasticscm_dirty)$ZSH_THEME_PLASTICSCM_PROMPT_SUFFIX$ZSH_PROMPT_BASE_COLOR"
  fi
  unset branch
}

function plasticscm_dirty_choose {
  result=`bcm status --short --controlledchanged 2> /dev/null`
  if [ -z "$result" ]; then
    unset result
    echo $2
    return
  fi
  unset result
  echo $1
}

function plasticscm_dirty {
  plasticscm_dirty_choose $ZSH_THEME_PLASTICSCM_PROMPT_DIRTY $ZSH_THEME_PLASTICSCM_PROMPT_CLEAN
}
