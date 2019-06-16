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

function hg_prompt_info {
  _DISPLAY=$(hg id --id --branch 2>/dev/null)
  if [ $_DISPLAY ]; then
    _REV=$_DISPLAY[(w)1]
    _BRANCH=$_DISPLAY[(w)2]
    if [[ $_REV =~ "\+" ]]; then
      _DIRTY=$ZSH_THEME_HG_PROMPT_DIRTY
    else
      _DIRTY=$ZSH_THEME_HG_PROMPT_CLEAN
    fi
    echo "$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_HG_PROMPT_PREFIX\
$ZSH_THEME_REPO_NAME_COLOR$_BRANCH$ZSH_PROMPT_BASE_COLOR$ZSH_PROMPT_BASE_COLOR$_DIRTY$ZSH_THEME_HG_PROMPT_SUFFIX$ZSH_PROMPT_BASE_COLOR"
    unset _REV
    unset _BRANCH
    unset _DIRTY
  fi
  unset _DISPLAY
}

function hgic() {
    hg incoming "$@" | grep "changeset" | wc -l
}

function hgoc() {
    hg outgoing "$@" | grep "changeset" | wc -l
}
