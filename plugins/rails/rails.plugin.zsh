# Rails 3 aliases, backwards-compatible with Rails 2.

function _rails_command () {
  if [ -e "script/server" ]; then
    ruby script/$@
  else
    if [ -e "bin/rails" ]; then
      bin/rails $@
    else
      rails $@
    fi
  fi
}

alias -g RED='RAILS_ENV=development'
alias -g RET='RAILS_ENV=test'
alias -g REP='RAILS_ENV=production'

alias rc='_rails_command console'
alias rd='_rails_command destroy'
alias rdb='_rails_command dbconsole'
alias rg='_rails_command generate'
alias rgm='_rails_command generate migration'
alias rp='_rails_command plugin'
alias rs='_rails_command server'
alias rsd='_rails_command server --debugger'
alias ru='_rails_command runner'

alias rdbm='_run-with-bundler rake db:migrate'
alias rdbr='_run-with-bundler rake db:rollback'
alias rdbs='_run-with-bundler rake db:seed'
alias rlc='_run-with-bundler rake log:clear'
alias rr='_run-with-bundler rake routes'

alias rspec='_run-with-bundler rspec'
alias cuke='_run-with-bundler cucumber'

alias devlog='tail -f log/development.log'
alias testlog='tail -f log/test.log'
alias prodlog='tail -f log/production.log'
