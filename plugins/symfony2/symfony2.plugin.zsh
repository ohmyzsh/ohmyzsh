# Symfony2 basic command completion

_symfony2_get_command_list () {
    if [ -f bin/console ]; then
	    php bin/console --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
    else
        php app/console --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
    fi
}

_symfony2 () {
  if [[ (-f app/console) || (-f bin/console) ]]; then
    compadd `_symfony2_get_command_list`
  fi
}

_symfony2_command () {
  if [ -f bin/console ]; then
    php bin/console $*
  else
    php app/console $*
  fi
}

compdef _symfony2 app/console
compdef _symfony2 bin/console
compdef _symfony2 _symfony2_command

#Alias
alias sf='_symfony2_command'
alias sfcl='_symfony2_command cache:clear'
alias sfroute='_symfony2_command router:debug'
alias sfgb='_symfony2_command generate:bundle'
alias sfcd='_symfony2_command container:debug'