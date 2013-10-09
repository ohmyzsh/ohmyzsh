# Laravel 4: Artisan basic command completion

_laravel4_get_command_list () {
    php artisan | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_laravel4 () {
    if [ -f artisan ]; then
        compadd `_laravel4_get_command_list`
    fi
}

compdef _laravel4 php artisan
compdef _laravel4 artisan

#Alias
alias artisan='php artisan'
alias artisan2cl='php artisan cache:clear'
alias artisan2routes='php artisan routes'
