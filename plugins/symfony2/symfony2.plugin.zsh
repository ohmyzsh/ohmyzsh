# Symfony2 basic command completion

_symfony2_get_command_list () {
	php app/console --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_symfony3_get_command_list () {
	php bin/console --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_symfony2 () {
  if [ -f app/console ]; then
    compadd `_symfony2_get_command_list`
  elif [ -f bin/console ]; then
    compadd `_symfony3_get_command_list`
  fi
}

_symfony_bin () {
  if [ -f app/console ]; then
    php app/console
  elif [ -f bin/console ]; then
    php bin/console
  fi
}

compdef _symfony2 app/console
compdef _symfony2 bin/console
compdef _symfony2 sf

#Alias
alias sf='_symfony_bin'
alias sfcl='_symfony_bin cache:clear'
alias sfcw='_symfony_bin cache:warmup'
alias sfroute='_symfony_bin router:debug'
alias sfcontainer='_symfony_bin container:debug'
alias sfgb='_symfony_bin generate:bundle'

