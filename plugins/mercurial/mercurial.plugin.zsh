# Mercurial
alias hga='hg add'
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
}
