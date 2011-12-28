# Aliases (compatible with Rails 2)
alias rc='_rails-command console'
alias rd='_rails-command destroy'
alias rdb='_rails-command dbconsole'
alias rdbm='rake db:migrate db:test:clone'
alias rg='_rails-command generate'
alias rp='_rails-command plugin'
alias rr='_rails-command runner'
alias rs='_rails-command server'
alias rsd='_rails-command server --debugger'
alias devlog='tail -f log/development.log'

# Functions
function _rails-command() {
  if [[ -e "script/server" ]]; then
    ruby script/"$@"
  else
    ruby script/rails "$@"
  fi
}

