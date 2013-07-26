alias ss='thin --stats "/thin/stats" start'
alias sg='ruby script/generate'
alias sd='ruby script/destroy'
alias sp='ruby script/plugin'
alias sr='ruby script/runner'
alias ssp='ruby script/spec'
alias rdbm='rake db:migrate'
alias rdbtp='rake db:test:prepare'
alias migrate='rake db:migrate && rake db:test:prepare'
alias sc='ruby script/console'
alias sd='ruby script/server --debugger'
alias devlog='tail -f log/development.log'
alias -g RET='RAILS_ENV=test'
alias -g REP='RAILS_ENV=production'
alias -g RED='RAILS_ENV=development'

function remote_console() {
  /usr/bin/env ssh $1 "( cd $2 && ruby script/console production )"
}
