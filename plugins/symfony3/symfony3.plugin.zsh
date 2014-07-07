#Symfony3 basic command completion

_symfony3_get_command_list () {
	php bin/console --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_symfony3 () {
  if [ -f bin/console ]; then
    compadd `_symfony3_get_command_list`
  fi
}

compdef _symfony3 bin/console
compdef _symfony3 sf3

#Alias
alias sf3='php bin/console'
alias sf3cl='php bin/console cache:clear'
alias sf3route='php bin/console router:debug'
alias sf3container='php bin/console container:debug'
alias sf3gb='php bin/console generate:bundle'
