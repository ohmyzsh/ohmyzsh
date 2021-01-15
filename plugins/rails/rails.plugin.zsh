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

function _rake_command () {
  if [ -e "bin/stubs/rake" ]; then
    bin/stubs/rake $@
  elif [ -e "bin/rake" ]; then
    bin/rake $@
  elif type bundle &> /dev/null && ([ -e "Gemfile" ] || [ -e "gems.rb" ]); then
    bundle exec rake $@
  else
    command rake $@
  fi
}

alias rails='_rails_command'
compdef _rails_command=rails

alias rake='_rake_command'
compdef _rake_command=rake

alias devlog='tail -f log/development.log'
alias prodlog='tail -f log/production.log'
alias testlog='tail -f log/test.log'

alias -g RED='RAILS_ENV=development'
alias -g REP='RAILS_ENV=production'
alias -g RET='RAILS_ENV=test'

# Rails aliases
alias rc='rails console'
alias rcs='rails console --sandbox'
alias rd='rails destroy'
alias rdb='rails dbconsole'
alias rgen='rails generate'
alias rgm='rails generate migration'
alias rp='rails plugin'
alias ru='rails runner'
alias rs='rails server'
alias rsd='rails server --debugger'
alias rsp='rails server --port'
alias rr='rails routes'
alias rrg='rails routes | grep'
alias rdm='rails db:migrate'
alias rdms='rails db:migrate:status'
alias rdr='rails db:rollback'
alias rdc='rails db:create'
alias rds='rails db:seed'
alias rdd='rails db:drop'
alias rdrs='rails db:reset'
alias rdtc='rails db:test:clone'
alias rdtp='rails db:test:prepare'
alias rdmtc='rails db:migrate db:test:clone'
alias rdsl='rails db:schema:load'
alias rlc='rails log:clear'
alias rn='rails notes'
alias rt='rails test'
alias rmd='rails middleware'
alias rsts='rails stats'

# Legacy rake aliases
alias rrdm='rake db:migrate'
alias rrdms='rake db:migrate:status'
alias rrdr='rake db:rollback'
alias rrdc='rake db:create'
alias rrds='rake db:seed'
alias rrdd='rake db:drop'
alias rrdrs='rake db:reset'
alias rrdtc='rake db:test:clone'
alias rrdtp='rake db:test:prepare'
alias rrdmtc='rake db:migrate db:test:clone'
alias rrdsl='rake db:schema:load'
alias rrlc='rake log:clear'
alias rrn='rake notes'
alias rrr='rake routes'
alias rrrg='rake routes | grep'
alias rrt='rake test'
alias rrmd='rake middleware'
alias rrsts='rake stats'

# legacy stuff
alias sstat='thin --stats "/thin/stats" start'
alias sg='ruby script/generate'
alias sd='ruby script/destroy'
alias sp='ruby script/plugin'
alias sr='ruby script/runner'
alias ssp='ruby script/spec'
alias sc='ruby script/console'
alias sd='ruby script/server --debugger'

function remote_console() {
  /usr/bin/env ssh $1 "( cd $2 && ruby script/console production )"
}
