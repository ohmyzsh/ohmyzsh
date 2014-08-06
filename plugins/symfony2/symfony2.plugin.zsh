# Symfony2/3 basic command completion

_symfony_console () {
    if [ -f bin/console ]; then
        echo "php bin/console"
    elif [ -f app/console ]; then
        echo "php app/console"
    fi
}

_symfony2_get_command_list () {
    `_symfony_console` --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_symfony2 () {
    compadd `_symfony2_get_command_list`
}

compdef _symfony2 '`_symfony_console`'
compdef _symfony2 sf

#Alias
alias sf='`_symfony_console`'
alias sfcl='sf cache:clear'
alias sfcw='sf cache:warmup'
alias sfroute='sf router:debug'
alias sfcontainer='sf container:debug'
alias sfgb='sf generate:bundle'