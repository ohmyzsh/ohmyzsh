# Rails 3 aliases, backwards-compatible with Rails 2.

function _bundle_command {
  if command -v bundle && [ -e "Gemfile" ]; then
    bundle exec $@
  else
    $@
  fi
}

function _rails_command () {
  if [ -e "script/server" ]; then
    ruby script/$@
  else
    ruby script/rails $@
  fi
}

alias rc='_rails_command console'
alias rd='_rails_command destroy'
alias rdb='_rails_command dbconsole'
alias rdbm='rake db:migrate db:test:clone'
alias rg='_rails_command generate'
alias rp='_rails_command plugin'
alias rs='_rails_command server'
alias rsd='_rails_command server --debugger'
alias devlog='tail -f log/development.log'

alias rspec='_bundle_command rspec'
alias cuke='_bundle_command cucumber'
