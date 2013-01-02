# Symfony2 basic command completion

_symfony2_get_command_list () {
	app/console --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_symfony2 () {
  if [ -f app/console ]; then
    compadd `_symfony2_get_command_list`
  fi
}

compdef _symfony2 app/console
compdef _symfony2 sf

#Alias
alias sf2='php app/console'
alias sf2clear='php app/console cache:clear'

