# Symfony2 basic command completion

_symfony2_get_command_list () {
	php app/console --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_symfony2_get_command_list_bin () {
	php bin/console --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_symfony2 () {
  if [ -f app/console ]; then
    compadd `_symfony2_get_command_list`
  fi
}

_symfony2_bin () {
  if [ -f bin/console ]; then
    compadd `_symfony2_get_command_list_bin`
  fi
}

compdef _symfony2 app/console
compdef _symfony2 sf

compdef _symfony2_bin bin/console
compdef _symfony2_bin sfb

#Alias
alias sf='php app/console'
alias sfcl='php app/console cache:clear'
alias sfroute='php app/console router:debug'

alias sfb='php bin/console'
alias sfclb='php bin/console cache:clear'
alias sfrouteb='php bin/console router:debug'
