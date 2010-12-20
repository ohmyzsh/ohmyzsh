alias rs='ruby script/rails server'
alias rg='ruby script/rails generate'
alias rd='ruby script/rails destroy'
alias rp='ruby script/rails plugin'
alias rdbm='rake db:migrate db:test:clone'
alias rc='ruby script/rails console'
alias rd='ruby script/rais server --debugger'
alias devlog='tail -f log/development.log'

function remote_console() {
  /usr/bin/env ssh $1 "( cd $2 && ruby script/rails console production )"
}
