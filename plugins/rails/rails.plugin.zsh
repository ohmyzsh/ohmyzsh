fpath=($ZSH/plugins/rails $fpath)
autoload -U compinit
compinit -i

function _rails () {
  if [ -e script/server ]; then
    ruby script/$@
  else
    ruby script/rails $@
  fi
}

function cuke () {
  bundle exec cucumber $@ -r features
}

alias rs='_rails server'
alias rd='_rails server --debugger'
alias rg='_rails generate'
alias rd='_rails destroy'
alias rp='_rails plugin'
alias rc='_rails console'
alias rdb='_rails dbconsole'
alias rdbm='rake db:migrate db:test:clone'
alias devlog='tail -f log/development.log'
