# Symfony2 basic command completion


function _symfony2_console {
    if [ -f bin/console ]; then
        CONSOLE=bin/console
    else
        CONSOLE=app/console
    fi

    echo $CONSOLE $1

    php $CONSOLE $1
}

_symfony2_get_command_list () {
  _symfony2_console --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_symfony2 () {
    if [ -f bin/console ]; then
        CONSOLE=bin/console
    else
        CONSOLE=app/console
    fi

  if [ -f $CONSOLE ]; then
    compadd `_symfony2_get_command_list`
  fi
}

compdef _symfony2 _symfony2_console
compdef _symfony2 sf

#Alias
alias sf=_symfony2_console
alias sfcl='_symfony2_console cache:clear'
alias sfroute='_symfony2_console router:debug'
alias sfcontainer='_symfony2_console container:debug'
alias sfgb='_symfony2_console generate:bundle'

