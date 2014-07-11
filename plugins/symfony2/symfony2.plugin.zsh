# Symfony2 basic command completion
if [[ -f app/console ]]; then
    symfony='app/console'
elif [[ -f bin/console ]]; then
    symfony='bin/console'
fi

_symfony2_get_command_list () {
    php app/console --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_symfony3_get_command_list () {
    php bin/console --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_symfony2 () {
    if [[ -f app/console ]]; then
        compadd `_symfony2_get_command_list`
    elif [[ -f bin/console ]]; then
        compadd `_symfony3_get_command_list`
    fi
}

compdef _symfony2 $symfony
compdef _symfony2 sf

#Alias
alias sf=$symfony
alias sfcl='$symfony cache:clear'
alias sfcw='$symfony cache:warmup'
alias sfroute='$symfony router:debug'
alias sfcontainer='$symfony container:debug'
alias sfgb='$symfony generate:bundle'

