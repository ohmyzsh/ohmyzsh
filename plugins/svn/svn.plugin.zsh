svn_prompt_info() {
  local info display
  info="$(LANG= svn info 2>/dev/null)" || return 1

  if [[ "$SVN_SHOW_BRANCH" = true ]]; then
    display="$(svn_get_branch_name "$info")"
  else
    display="$(svn_get_repo_name "$info")"
  fi

  printf '%s%s%s%s%s%s%s%s%s%s' \
    "$ZSH_PROMPT_BASE_COLOR" \
    "$ZSH_THEME_SVN_PROMPT_PREFIX" \
    "$ZSH_THEME_REPO_NAME_COLOR" \
    "${display:gs/%/%%}" \
    "$ZSH_PROMPT_BASE_COLOR" \
    "$ZSH_THEME_SVN_PROMPT_SUFFIX" \
    "$ZSH_PROMPT_BASE_COLOR" \
    "$(svn_dirty $info)" \
    "$(svn_dirty_pwd)" \
    "$ZSH_PROMPT_BASE_COLOR"
}

in_svn() {
  svn info &>/dev/null
}

svn_get_repo_name() {
  local info name
  info="${1:-$(LANG= svn info 2>/dev/null)}"
  name="$(sed -n 's/^Repository\ Root:\ .*\///p' <<< "$info")"
  omz_urldecode "$name"
}

svn_get_branch_name() {
  local info branch
  info="${1:-$(LANG= svn info 2>/dev/null)}"
  branch=$(
    awk -F/ '/^URL:/ {
      for (i=0; i<=NF; i++) {
        if ($i == "branches" || $i == "tags" ) {
          print $(i+1)
          break
        };
        if ($i == "trunk") {
          print $i
          break
        }
      }
    }' <<< "$info"
  )
  branch="$(omz_urldecode "$branch")"

  echo "${branch:-$(svn_get_repo_name "$info")}"
}

svn_get_rev_nr() {
  sed -n 's/Revision:\ //p' "${1:-$(LANG= svn info 2>/dev/null)}"
}

svn_dirty() {
  svn_dirty_choose "${1:-$(LANG= svn info 2>/dev/null)}" $ZSH_THEME_SVN_PROMPT_DIRTY $ZSH_THEME_SVN_PROMPT_CLEAN
}

svn_dirty_choose() {
  local root
  root=$(sed -n 's/^Working Copy Root Path: //p' <<< "${1:-$(LANG= svn info 2>/dev/null)}")
  if LANG= svn status "$root" 2>/dev/null | command grep -Eq '^\s*[ACDIM!?L]'; then
    # Grep exits with 0 when "One or more lines were selected", return "dirty".
    echo $1
  else
    # Otherwise, no lines were found, or an error occurred. Return clean.
    echo $2
  fi
}

svn_dirty_pwd () {
  svn_dirty_choose_pwd $ZSH_THEME_SVN_PROMPT_DIRTY_PWD $ZSH_THEME_SVN_PROMPT_CLEAN_PWD
}

svn_dirty_choose_pwd () {
  if LANG= svn status "$PWD" 2>/dev/null | command grep -Eq '^\s*[ACDIM!?L]'; then
    # Grep exits with 0 when "One or more lines were selected", return "dirty".
    echo $1
  else
    # Otherwise, no lines were found, or an error occurred. Return clean.
    echo $2
  fi
}
