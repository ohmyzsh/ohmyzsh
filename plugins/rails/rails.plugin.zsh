fpath=($ZSH/plugins/rails $fpath)
autoload -U compinit
compinit -i

function _rails_command () {
  if [ -e "script/server" ]; then
    ruby script/$@
  else
    ruby script/rails $@
  fi
}

alias rs='_rails_command server'
alias rd='_rails_command server --debugger'
alias rg='_rails_command generate'
alias rd='_rails_command destroy'
alias rp='_rails_command plugin'
alias rc='_rails_command console'
alias rdb='_rails_command dbconsole'
alias rdbm='rake db:migrate db:test:clone'
alias devlog='tail -f log/development.log'
alias cuke='bundle exec cucumber'
