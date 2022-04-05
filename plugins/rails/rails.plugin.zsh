# rails command wrapper
function _rails_command () {
  if [ -e "bin/stubs/rails" ]; then
    bin/stubs/rails $@
  elif [ -e "bin/rails" ]; then
    bin/rails $@
  elif [ -e "script/rails" ]; then
    ruby script/rails $@
  elif [ -e "script/server" ]; then
    ruby script/$@
  else
    command rails $@
  fi
}

alias rails='_rails_command'
compdef _rails_command=rails

# rake command wrapper
function _rake_command () {
  if [ -e "bin/stubs/rake" ]; then
    bin/stubs/rake $@
  elif [ -e "bin/rake" ]; then
    bin/rake $@
  elif type bundle &> /dev/null && [[ -e "Gemfile" || -e "gems.rb" ]]; then
    bundle exec rake $@
  else
    command rake $@
  fi
}

alias rake='_rake_command'
compdef _rake_command=rake

# Log aliases
alias devlog='tail -f log/development.log'
alias prodlog='tail -f log/production.log'
alias testlog='tail -f log/test.log'

# Environment settings
alias -g RED='RAILS_ENV=development'
alias -g REP='RAILS_ENV=production'
alias -g RET='RAILS_ENV=test'

# Rails aliases
alias rc='rails console'
alias rcs='rails console --sandbox'
alias rd='rails destroy'
alias rdb='rails dbconsole'
alias rdc='rails db:create'
alias rdd='rails db:drop'
alias rdm='rails db:migrate'
alias rdmd='rails db:migrate:down'
alias rdmr='rails db:migrate:redo'
alias rdms='rails db:migrate:status'
alias rdmtc='rails db:migrate db:test:clone'
alias rdmu='rails db:migrate:up'
alias rdr='rails db:rollback'
alias rdrs='rails db:reset'
alias rds='rails db:seed'
alias rdsl='rails db:schema:load'
alias rdtc='rails db:test:clone'
alias rdtp='rails db:test:prepare'
alias rgen='rails generate'
alias rgm='rails generate migration'
alias rlc='rails log:clear'
alias rmd='rails middleware'
alias rn='rails notes'
alias rp='rails plugin'
alias rr='rails routes'
alias rrg='rails routes | grep'
alias rs='rails server'
alias rsb='rails server --bind'
alias rsd='rails server --debugger'
alias rsp='rails server --port'
alias rsts='rails stats'
alias rt='rails test'
alias ru='rails runner'

# Foreman aliases
alias fmns='foreman start'

# Rake aliases
alias rkdc='rake db:create'
alias rkdd='rake db:drop'
alias rkdm='rake db:migrate'
alias rkdmd='rake db:migrate:down'
alias rkdmr='rake db:migrate:redo'
alias rkdms='rake db:migrate:status'
alias rkdmtc='rake db:migrate db:test:clone'
alias rkdmu='rake db:migrate:up'
alias rkdr='rake db:rollback'
alias rkdrs='rake db:reset'
alias rkds='rake db:seed'
alias rkdsl='rake db:schema:load'
alias rkdtc='rake db:test:clone'
alias rkdtp='rake db:test:prepare'
alias rklc='rake log:clear'
alias rkmd='rake middleware'
alias rkn='rake notes'
alias rksts='rake stats'
alias rkt='rake test'

# legacy stuff
alias sc='ruby script/console'
alias sd='ruby script/destroy'
alias sd='ruby script/server --debugger'
alias sg='ruby script/generate'
alias sp='ruby script/plugin'
alias sr='ruby script/runner'
alias ssp='ruby script/spec'
alias sstat='thin --stats "/thin/stats" start'

function remote_console() {
  /usr/bin/env ssh $1 "( cd $2 && ruby script/console production )"
}
