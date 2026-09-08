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
alias rdmrs='rails db:migrate:reset'
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

# Database tasks
#
# Rails applications can define more than one database (primary, cache, cable,
# queue, ...). Each one gets its own namespaced task, e.g. `db:migrate:cache`.
# The functions below take an optional database name as the first argument:
#
#   rdm                    ->  rails db:migrate
#   rdm cache              ->  rails db:migrate:cache
#   rdm VERSION=20231225   ->  rails db:migrate VERSION=20231225
#   rdm cache STEP=2       ->  rails db:migrate:cache STEP=2
#   rdm --trace            ->  rails db:migrate --trace
#
# The first argument is read as a database name only when it is a bare word.
# Flags (--trace), variables (STEP=2) and other tasks (db:seed) are passed
# through to rails untouched, so the previous alias behavior still works.
function _rails_db_command() {
  local task="$1"
  shift

  if [[ $# -gt 0 && "$1" != -* && "$1" != *=* && "$1" != *:* ]]; then
    task="$task:$1"
    shift
    # Echo the resolved task so it is clear which database is being used
    local -a cmd=(rails "$task" "$@")
    print -u2 -r -- "Running: ${cmd[*]}"
  fi

  rails "$task" "$@"
}

function rdc()  { _rails_db_command db:create "$@" }
function rdd()  { _rails_db_command db:drop "$@" }
function rdm()  { _rails_db_command db:migrate "$@" }
function rdmd() { _rails_db_command db:migrate:down "$@" }
function rdmr() { _rails_db_command db:migrate:redo "$@" }
function rdms() { _rails_db_command db:migrate:status "$@" }
function rdmu() { _rails_db_command db:migrate:up "$@" }
function rdr()  { _rails_db_command db:rollback "$@" }
function rdrs() { _rails_db_command db:reset "$@" }
function rdsl() { _rails_db_command db:schema:load "$@" }

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
