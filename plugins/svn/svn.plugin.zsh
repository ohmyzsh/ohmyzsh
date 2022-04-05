<<<<<<< HEAD
# vim:ft=zsh ts=2 sw=2 sts=2
#
function svn_prompt_info() {
  if in_svn; then
    if [ "x$SVN_SHOW_BRANCH" = "xtrue" ]; then
      unset SVN_SHOW_BRANCH
      _DISPLAY=$(svn_get_branch_name)
    else
      _DISPLAY=$(svn_get_repo_name)
    fi
    echo "$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_PREFIX\
$ZSH_THEME_REPO_NAME_COLOR$_DISPLAY$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_SUFFIX$ZSH_PROMPT_BASE_COLOR$(svn_dirty)$(svn_dirty_pwd)$ZSH_PROMPT_BASE_COLOR"
    unset _DISPLAY
  fi
}


function in_svn() {
  if $(svn info >/dev/null 2>&1); then
    return 0
  fi
  return 1
}

function svn_get_repo_name() {
  if in_svn; then
    svn info | sed -n 's/Repository\ Root:\ .*\///p' | read SVN_ROOT
    svn info | sed -n "s/URL:\ .*$SVN_ROOT\///p"
  fi
}

function svn_get_branch_name() {
  _DISPLAY=$(
    svn info 2> /dev/null | \
      awk -F/ \
      '/^URL:/ { \
        for (i=0; i<=NF; i++) { \
          if ($i == "branches" || $i == "tags" ) { \
            print $(i+1); \
            break;\
          }; \
          if ($i == "trunk") { print $i; break; } \
        } \
      }'
  )
  
  if [ "x$_DISPLAY" = "x" ]; then
    svn_get_repo_name
  else
    echo $_DISPLAY
  fi
  unset _DISPLAY
}

function svn_get_rev_nr() {
  if in_svn; then
    svn info 2> /dev/null | sed -n 's/Revision:\ //p'
  fi
}

function svn_dirty_choose() {
  if in_svn; then
    root=`svn info 2> /dev/null | sed -n 's/^Working Copy Root Path: //p'`
    if $(svn status $root 2> /dev/null | command grep -Eq '^\s*[ACDIM!?L]'); then
      # Grep exits with 0 when "One or more lines were selected", return "dirty".
      echo $1
    else
      # Otherwise, no lines were found, or an error occurred. Return clean.
      echo $2
    fi
  fi
}

function svn_dirty() {
  svn_dirty_choose $ZSH_THEME_SVN_PROMPT_DIRTY $ZSH_THEME_SVN_PROMPT_CLEAN
}

function svn_dirty_choose_pwd () {
  if in_svn; then
    root=$PWD
    if $(svn status $root 2> /dev/null | command grep -Eq '^\s*[ACDIM!?L]'); then
      # Grep exits with 0 when "One or more lines were selected", return "dirty".
      echo $1
    else
      # Otherwise, no lines were found, or an error occurred. Return clean.
      echo $2
    fi
  fi
}

function svn_dirty_pwd () {
  svn_dirty_choose_pwd $ZSH_THEME_SVN_PROMPT_DIRTY_PWD $ZSH_THEME_SVN_PROMPT_CLEAN_PWD
}


=======
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
  sed -n 's/Revision:\ //p' <<<"${1:-$(LANG= svn info 2>/dev/null)}"
}

svn_dirty() {
  svn_dirty_choose "${1:-$(LANG= svn info 2>/dev/null)}" $ZSH_THEME_SVN_PROMPT_DIRTY $ZSH_THEME_SVN_PROMPT_CLEAN
}

svn_dirty_choose() {
  local root
  root=$(sed -n 's/^Working Copy Root Path: //p' <<< "${1:-$(LANG= svn info 2>/dev/null)}")
  if LANG= svn status "$root" 2>/dev/null | command grep -Eq '^\s*[ACDIM!?L]'; then
    # Grep exits with 0 when "One or more lines were selected", return "dirty".
    echo $2
  else
    # Otherwise, no lines were found, or an error occurred. Return clean.
    echo $3
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
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
