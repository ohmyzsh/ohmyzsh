# Mercurial
alias hgc='hg commit'
alias hgb='hg branch'
alias hgba='hg branches'
alias hgbk='hg bookmarks'
alias hgco='hg checkout'
alias hgd='hg diff'
alias hged='hg diffmerge'
# pull and update
alias hgi='hg incoming'
alias hgl='hg pull -u'
alias hglr='hg pull --rebase'
alias hgo='hg outgoing'
alias hgp='hg push'
alias hgs='hg status'
alias hgsl='hg log --limit 20 --template "{node|short} | {date|isodatesec} | {author|user}: {desc|strip|firstline}\n" '
alias hgca='hg commit --amend'
# list unresolved files (since hg does not list unmerged files in the status command)
alias hgun='hg resolve --list'

function hg_get_dir() {
  # Defines path as current directory
  local current_dir=$PWD
  # While current path is not root path
  while [[ $current_dir != '/' ]]; do
    if [[ -d "${current_dir}/.hg" ]]; then
      echo "${current_dir}/.hg"
      return
    fi
    # Defines path as parent directory and keeps looking for
    current_dir="${current_dir:h}"
  done
}

function in_hg() {
  if [[ $(hg_get_dir) != "" ]]; then
    echo 1
  fi
}

function hg_get_branch_id() {
  local hg_id_tip=`hg log -T "{node|short}" -l 1 -b .`
  local hg_id=`hg id -i -r .`

  if [[ $hg_id != $hg_id_tip ]]; then
    echo "@${hg_id}"
  fi
}

function hg_get_branch_name() {
  local hg_dir=$(hg_get_dir)
  if [[ $hg_dir != "" ]]; then
    local hg_id=$(hg_get_branch_id)
    if [[ -f "${hg_dir}/branch" ]]; then
      echo $(<"${hg_dir}/branch")$hg_id
    else
      echo "default${hg_id}"
    fi
  fi
}

function hg_prompt_info {
  local branch=$(hg_get_branch_name)
  if [[ $branch != "" ]]; then
    echo "$ZSH_THEME_HG_PROMPT_PREFIX${branch}$(hg_dirty)$ZSH_THEME_HG_PROMPT_SUFFIX"
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
}
