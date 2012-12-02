
# Mercurial
alias hgc='hg commit'
alias hgb='hg branch'
alias hgba='hg branches'
alias hgco='hg checkout'
alias hgd='hg diff'
alias hged='hg diffmerge'
# pull and update
alias hgl='hg pull -u'
alias hgp='hg push'
alias hgs='hg status'
# this is the 'git commit --amend' equivalent
alias hgca='hg qimport -r tip ; hg qrefresh -e ; hg qfinish tip'

function hg_current_branch() {
  local ref=$(hg branch 2>/dev/null) || return
  echo $ref
}

function parse_hg_dirty() {
  local num_status=$(hg status | wc -l)
  if [ $num_status -eq 0 ]; then
  	echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  else
  	echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  fi
}