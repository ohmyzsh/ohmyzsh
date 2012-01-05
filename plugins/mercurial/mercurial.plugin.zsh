
# Mercurial
alias hgc='hg commit -v'
alias hgb='hg branch -v'
alias hgba='hg branches'
alias hgco='hg checkout'
alias hgd='hg diff'
alias hged='hg diffmerge'
# pull and update
# show incoming commits with log msg, pull them in if there are any and update
alias hgup='hg in && hg pull -u -v'
alias hgl='hg pull -u -v'
alias hgp='hg push -v'
alias hgs='hg status -v'
# this is the 'git commit --amend' equivalent
alias hgca='hg qimport -r tip ; hg qrefresh -e ; hg qfinish tip'
