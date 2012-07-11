
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

# Theme vars and functions
ZSH_THEME_HG_PROMPT_PREFIX="hg:("          # Prefix at the very beginning of the prompt, before the branch name
ZSH_THEME_HG_PROMPT_SUFFIX=")"             # At the very end of the prompt
ZSH_THEME_HG_PROMPT_DIRTY="*"              # Text to display if the branch is dirty
ZSH_THEME_HG_PROMPT_CLEAN=""               # Text to display if the branch is clean

# get the name of the branch we are on
function hg_prompt_info() {
  ref=$(hg branch 2> /dev/null) || return
  echo "$ZSH_THEME_HG_PROMPT_PREFIX${ref}$(parse_hg_dirty)$ZSH_THEME_HG_PROMPT_SUFFIX"
}

# Checks if working tree is dirty
parse_hg_dirty() {
  if [[ -n $(hg status 2> /dev/null) ]]; then
    echo "$ZSH_THEME_HG_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_HG_PROMPT_CLEAN"
  fi
}

