function pj_install() {
  npm install -g projen
}

function pj_pr_rebuild() {
  local pr="$1"

  gh pr review "$pr" --comment --body "@projen rebuild"
}

alias pgjn='projen new'
alias pgjv='projen --version'

alias pj='npx projen'

alias pjv='pj --version'
alias pjb='pj build'

alias pjd='pj deploy'
alias pjdd='pj diff'
alias pjD='pj destroy'

alias pjU='pj projen:upgrade'

alias pjR='pj_pr_rebuild'
