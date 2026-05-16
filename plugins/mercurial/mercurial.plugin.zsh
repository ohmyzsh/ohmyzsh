# aliases
alias hga='hg add'
alias hgc='hg commit'
alias hgca='hg commit --amend'
alias hgci='hg commit --interactive'
alias hgb='hg branch'
alias hgba='hg branches'
alias hgbk='hg bookmarks'
alias hgco='hg checkout'
alias hgd='hg diff'
alias hged='hg diffmerge'
alias hgp='hg push'
alias hgs='hg status'
alias hgsl='hg log --limit 20 --template "{node|short} | {date|isodatesec} | {author|person}: {desc|strip|firstline}\n" '
alias hgun='hg resolve --list'
# pull and update
alias hgi='hg incoming'
alias hgl='hg pull -u'
alias hglr='hg pull --rebase'
alias hgo='hg outgoing'
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
}
