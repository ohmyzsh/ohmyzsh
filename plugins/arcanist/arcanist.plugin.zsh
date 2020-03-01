#
# Aliases
# (sorted alphabetically)
#

alias ara='arc amend'
alias arb='arc branch'
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
alias arl='arc land'
alias arli='arc lint'
alias arls='arc list'

#
# Functions
# (sorted alphabetically)
#

_extract_revision_id(){
  # helper function to extract everything after the last slash.
  # If there is no slash, returns the whole variable
  local -a URL
  URL=("${(s:/:)1}") # split by slash
  echo "${URL[-1]}"
}

ardu() {
# With this, both, `ardu https://arcanist-url.com/<REVISION>`, and `ardu <REVISION>` work.
  arc diff --update "$(_extract_revision_id $1)"
}

arpa() {
# With this, both, `arpa https://arcanist-url/.com/<REVISION>`, and `arpa <REVISION>` work.
  arc patch "$(_extract_revision_id $1)"
}
