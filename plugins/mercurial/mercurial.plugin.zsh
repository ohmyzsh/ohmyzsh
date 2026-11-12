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

ZSH_THEME_HG_PROMPT_IDENTIFY_DEFAULT='{separate(" ",ifeq(branch,"default","",branch),strip(bookmarks % "{bookmark}{ifeq(bookmark,activebookmark,"*")} "),tags)}'

function hg_prompt_info {
  if ! hg_root >/dev/null; then
    return
  fi

  local pieces dirty
  if ! pieces="$(hg identify -T'{if(dirty,"x","-")} '"${ZSH_THEME_HG_PROMPT_IDENTIFY:-$ZSH_THEME_HG_PROMPT_IDENTIFY_DEFAULT}")"; then
    return
  fi
  dirty="${pieces%% *}"
  pieces="${pieces#* }"
  dirty="${dirty%-}"

  # Check for untracked files unless that is disabled or the repo is already known to be dirty.
  if [[ x"${DISABLE_UNTRACKED_FILES_DIRTY-}" != xtrue && -z "$dirty" ]]; then
    dirty="$(hg status -u --template=x 2>/dev/null | head -c1; [[ 0 = ${pipestatus[1]} ]] || echo error)"
    case "$dirty" in
      error) return ;;
    esac
  fi

  case "$dirty" in
    ?*) dirty="$ZSH_THEME_HG_PROMPT_DIRTY" ;;
    '') dirty="$ZSH_THEME_HG_PROMPT_CLEAN" ;;
  esac
  echo "${ZSH_THEME_HG_PROMPT_PREFIX}${pieces:gs/%/%%}$dirty${ZSH_THEME_HG_PROMPT_SUFFIX}"
}
