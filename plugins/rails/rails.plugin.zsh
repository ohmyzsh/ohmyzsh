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
alias rdmtc='rails db:migrate db:test:clone'
alias rds='rails db:seed'
alias rdtc='rails db:test:clone'
alias rdtp='rails db:test:prepare'
alias rgen='rails generate'
alias rgm='rails generate migration'
alias rlc='rails log:clear'
alias rmd='rails middleware'
alias rn='rails notes'
alias rp='rails plugin'
alias rr='rails routes'
alias rrc='rails routes --controller'
alias rre='rails routes --expanded'
alias rrg='rails routes --grep'
alias rru='rails routes --unused'
alias rs='rails server'
alias rsb='rails server --bind'
alias rsd='rails server --debugger'
alias rsp='rails server --port'
alias rsts='rails stats'
alias rt='rails test'
alias rta='rails test:all'
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

# Multi-database functions
# Usage: rdc <database> - rails db:create:<database>
function rdc() {
  if [ -z "$1" ]; then
    rails db:create
  else
    rails db:create:$1
  fi
}

# Usage: rdd <database> - rails db:drop:<database>
function rdd() {
  if [ -z "$1" ]; then
    rails db:drop
  else
    rails db:drop:$1
  fi
}

# Usage: rdm <database> - rails db:migrate:<database>
function rdm() {
  if [ -z "$1" ]; then
    rails db:migrate
  else
    rails db:migrate:$1
  fi
}

# Usage: rdmd <database> - rails db:migrate:down:<database>
function rdmd() {
  if [ -z "$1" ]; then
    rails db:migrate:down
  else
    rails db:migrate:down:$1
  fi
}

# Usage: rdmr <database> - rails db:migrate:redo:<database>
function rdmr() {
  if [ -z "$1" ]; then
    rails db:migrate:redo
  else
    rails db:migrate:redo:$1
  fi
}

# Usage: rdms <database> - rails db:migrate:status:<database>
function rdms() {
  if [ -z "$1" ]; then
    rails db:migrate:status
  else
    rails db:migrate:status:$1
  fi
}

# Usage: rdmu <database> - rails db:migrate:up:<database>
function rdmu() {
  if [ -z "$1" ]; then
    rails db:migrate:up
  else
    rails db:migrate:up:$1
  fi
}

# Usage: rdr <database> - rails db:rollback:<database>
function rdr() {
  if [ -z "$1" ]; then
    rails db:rollback
  else
    rails db:rollback:$1
  fi
}

# Usage: rdrs <database> - rails db:reset:<database>
function rdrs() {
  if [ -z "$1" ]; then
    rails db:reset
  else
    rails db:reset:$1
  fi
}

# Usage: rdsl <database> - rails db:schema:load:<database>
function rdsl() {
  if [ -z "$1" ]; then
    rails db:schema:load
  else
    rails db:schema:load:$1
  fi
}

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
