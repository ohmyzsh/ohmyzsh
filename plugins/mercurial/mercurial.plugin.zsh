
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
# this is the 'git commit --amend' equivalent
alias hgca='hg qimport -r tip ; hg qrefresh -e ; hg qfinish tip'

function hg_current_branch() {
  if [ -d .hg ]; then
    echo hg:$(hg branch)
  fi
}

function parse_hg_dirty() {
  if [[ -n $(hg status -mard . 2> /dev/null) ]]; then
    echo "$ZSH_THEME_HG_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_HG_PROMPT_CLEAN"
  fi
}

function hg_prompt_info() {
  if [ -d .hg ]; then
  	echo "$ZSH_THEME_HG_PROMPT_PREFIX$(hg branch)$(parse_hg_dirty)$ZSH_THEME_HG_PROMPT_SUFFIX"
  fi
}
