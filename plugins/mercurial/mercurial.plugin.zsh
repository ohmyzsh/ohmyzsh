<<<<<<< HEAD
# Mercurial
alias hgc='hg commit'
=======
# aliases
alias hga='hg add'
alias hgc='hg commit'
alias hgca='hg commit --amend'
alias hgci='hg commit --interactive'
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
alias hgb='hg branch'
alias hgba='hg branches'
alias hgbk='hg bookmarks'
alias hgco='hg checkout'
alias hgd='hg diff'
alias hged='hg diffmerge'
<<<<<<< HEAD
=======
alias hgp='hg push'
alias hgs='hg status'
alias hgsl='hg log --limit 20 --template "{node|short} | {date|isodatesec} | {author|person}: {desc|strip|firstline}\n" '
alias hgun='hg resolve --list'
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
# pull and update
alias hgi='hg incoming'
alias hgl='hg pull -u'
alias hglr='hg pull --rebase'
alias hgo='hg outgoing'
<<<<<<< HEAD
alias hgp='hg push'
alias hgs='hg status'
alias hgsl='hg log --limit 20 --template "{node|short} | {date|isodatesec} | {author|user}: {desc|strip|firstline}\n" '
# this is the 'git commit --amend' equivalent
alias hgca='hg qimport -r tip ; hg qrefresh -e ; hg qfinish tip'
# list unresolved files (since hg does not list unmerged files in the status command)
alias hgun='hg resolve --list'

function in_hg() {
  if [[ -d .hg ]] || $(hg summary > /dev/null 2>&1); then
    echo 1
  fi
}

function hg_get_branch_name() {
  if [ $(in_hg) ]; then
    echo $(hg branch)
  fi
}

function hg_prompt_info {
  if [ $(in_hg) ]; then
    _DISPLAY=$(hg_get_branch_name)
    echo "$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_HG_PROMPT_PREFIX\
$ZSH_THEME_REPO_NAME_COLOR$_DISPLAY$ZSH_PROMPT_BASE_COLOR$ZSH_PROMPT_BASE_COLOR$(hg_dirty)$ZSH_THEME_HG_PROMPT_SUFFIX$ZSH_PROMPT_BASE_COLOR"
    unset _DISPLAY
  fi
}

function hg_dirty_choose {
  if [ $(in_hg) ]; then
    hg status 2> /dev/null | command grep -Eq '^\s*[ACDIM!?L]'
    if [ $pipestatus[-1] -eq 0 ]; then
      # Grep exits with 0 when "One or more lines were selected", return "dirty".
      echo $1
    else
      # Otherwise, no lines were found, or an error occurred. Return clean.
      echo $2
    fi
  fi
}

function hg_dirty {
  hg_dirty_choose $ZSH_THEME_HG_PROMPT_DIRTY $ZSH_THEME_HG_PROMPT_CLEAN
}

function hgic() {
    hg incoming "$@" | grep "changeset" | wc -l
}

function hgoc() {
    hg outgoing "$@" | grep "changeset" | wc -l
=======
alias hglg='hg log --stat -v'
alias hglgp='hg log --stat  -p -v'

function hgic() {
  hg incoming "$@" | grep "changeset" | wc -l
}

function hgoc() {
  hg outgoing "$@" | grep "changeset" | wc -l
}

# functions
function hg_root() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/.hg" ]]; then
      echo "$dir"
      return 0
    fi
    dir="${dir:h}"
  done
  return 1
}

function in_hg() {
  hg_root >/dev/null
}

function hg_get_branch_name() {
  local dir
  if ! dir=$(hg_root); then
    return
  fi

  if [[ ! -f "$dir/.hg/branch" ]]; then
    echo default
    return
  fi

  echo "$(<"$dir/.hg/branch")"
}

function hg_get_bookmark_name() {
  local dir
  if ! dir=$(hg_root); then
    return
  fi

  if [[ ! -f "$dir/.hg/bookmarks.current" ]]; then
    return
  fi

  echo "$(<"$dir/.hg/bookmarks.current")"
}

function hg_prompt_info {
  local dir branch dirty
  if ! dir=$(hg_root); then
    return
  fi

  if [[ ! -f "$dir/.hg/branch" ]]; then
    branch=default
  else
    branch="$(<"$dir/.hg/branch")"
  fi

  dirty="$(hg_dirty)"

  echo "${ZSH_THEME_HG_PROMPT_PREFIX}${branch:gs/%/%%}${dirty}${ZSH_THEME_HG_PROMPT_SUFFIX}"
}

function hg_dirty {
  # Do nothing if clean / dirty settings aren't defined
  if [[ -z "$ZSH_THEME_HG_PROMPT_DIRTY" && -z "$ZSH_THEME_HG_PROMPT_CLEAN" ]]; then
    return
  fi

  # Check if there are modifications
  local hg_status
  if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" = true ]]; then
    if ! hg_status="$(hg status -q 2>/dev/null)"; then
      return
    fi
  else
    if ! hg_status="$(hg status 2>/dev/null)"; then
      return
    fi
  fi

  # grep exits with 0 when dirty
  if command grep -Eq '^\s*[ACDIMR!?L].*$' <<< "$hg_status"; then
    echo $ZSH_THEME_HG_PROMPT_DIRTY
    return
  fi

  echo $ZSH_THEME_HG_PROMPT_CLEAN
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}
