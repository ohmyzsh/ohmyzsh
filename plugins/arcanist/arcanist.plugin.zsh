#
# Aliases
# (sorted alphabetically)
#

alias ara='arc amend'
alias arb='arc branch'
alias arbl='arc bland'
alias arco='arc cover'
alias arci='arc commit'

alias ard='arc diff'
alias ardc='arc diff --create'
alias ardnu='arc diff --nounit'
alias ardnupc='arc diff --nounit --plan-changes'
alias ardpc='arc diff --plan-changes'
alias ardp='arc diff --preview' # creates a new diff in the phab interface

alias are='arc export'
alias arh='arc help'
alias arho='arc hotfix'
alias arl='arc land'
alias arli='arc lint'
alias arls='arc list'

#
# Functions
# (sorted alphabetically)
#

ardu() {
  # Both `ardu https://arcanist-url.com/<REVISION>`, and `ardu <REVISION>` work.
  arc diff --update "${1:t}"
}

arpa() {
  # Both `arpa https://arcanist-url.com/<REVISION>`, and `arpa <REVISION>` work.
  arc patch "${1:t}"
}
