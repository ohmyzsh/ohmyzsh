# Symfony2 basic command completion

_symfony2_get_command_list () {
	php bin/console --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_symfony2 () {
  if [ -f bin/console ]; then
    compadd `_symfony2_get_command_list`
  fi
}

compdef _symfony2 bin/console
compdef _symfony2 sf25

#Alias
alias sf25='php bin/console'
alias sf25cl='php bin/console cache:clear'
alias sf25route='php bin/console router:debug'
alias sf25gb='php bin/console generate:bundle'
alias sf25cfg='php bin/console config:debug'
