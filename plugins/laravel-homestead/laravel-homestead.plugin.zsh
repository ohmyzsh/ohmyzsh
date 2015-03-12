###########################################
# Laravel homestead command completion    #
# Author: Casper Lai                      #
# Email: casper.lai@outlook.com           #
# Reference: Laravel5 plugin              #
###########################################

_laravel_homestead_get_command_list () {
    homestead --no-ansi | sed "1,/Available commands/d" | awk '/^ +[a-z]+/ { print $1 }'
}

_laravel_homestead () {
    compadd `_laravel_homestead_get_command_list`
}

compdef _laravel_homestead homestead