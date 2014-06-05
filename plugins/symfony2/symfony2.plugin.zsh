# Symfony2 basic command completion

if [ -f app/console ]; then
  console="app/console"
else
  console="bin/console"
fi

_symfony2_get_command_list () {
	php $console --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_symfony2 () {
  if [ -f $console ]; then
    compadd `_symfony2_get_command_list`
  fi
}

compdef _symfony2 $console
compdef _symfony2 sf

#Alias
alias sf='php $console'
alias sfcl='php $console cache:clear'
alias sfroute='php $console router:debug'
alias sfgb='php $console generate:bundle'

