# Rails 4 aliases

function _rails_command () {
  if [ -e "script/server" ]; then
    ruby script/$@
  elif [ -e "script/rails" ]; then
    ruby script/rails $@
  else
    ruby bin/rails $@  
  fi
}

alias rc='_rails_command console'
alias rd='_rails_command destroy'
alias rdb='_rails_command dbconsole'
alias rdbm='rake db:migrate db:test:clone'
alias rg='_rails_command generate'
alias rgm='_rails_command generate migration'
alias rp='_rails_command plugin'
alias ru='_rails_command runner'
alias rs='_rails_command server'
alias rsd='_rails_command server --debugger'
alias devlog='tail -f log/development.log'
alias testlog='tail -f log/test.log'
alias prodlog='tail -f log/production.log'
alias rdm='rake db:migrate'
alias rdc='rake db:create'
alias rdr='rake db:rollback'
alias rds='rake db:seed'
alias rlc='rake log:clear'
alias rn='rake notes'
alias rr='rake routes'
