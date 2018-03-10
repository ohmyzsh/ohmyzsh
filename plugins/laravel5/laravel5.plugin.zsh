# Laravel5 basic command completion
_laravel5_get_command_list () {
	php artisan --raw --no-ansi list | sed "s/[[:space:]].*//g"
}

_laravel5 () {
  if [ -f artisan ]; then
    compadd `_laravel5_get_command_list`
  fi
}

compdef _laravel5 artisan
compdef _laravel5 la5

# auth
alias la5remclear='php artisan auth:clear-reminders'
alias la5remcontroller='php artisan auth:reminders-controller'
alias la5remtable='php artisan auth:reminders-table'

# cache
alias la5cacheclear='php artisan cache:clear'

# command
alias la5command='php artisan command:make'

# config
alias la5confpub='php artisan config:publish'

# controller
alias la5controller='php artisan make:controller'

# db
alias la5seed='php artisan db:seed'

# key
alias la5key='php artisan key:generate'

# migrate
alias la5migrate='php artisan migrate'
alias la5mig='la5migrate'
alias la5miginstall='php artisan migrate:install'
alias la5migmake='php artisan migrate:make'
alias la5migcreate='php artisan migrate:create'
alias la5migpublish='php artisan migrate:publish'
alias la5migrefresh='php artisan migrate:refresh'
alias la5migreset='php artisan migrate:reset'
alias la5migrollback='php artisan migrate:rollback'
alias la5rollback='la5migrollback'

# queue
alias la5qfailed='php artisan queue:failed'
alias la5qfailedtable='php artisan queue:failed-table'
alias la5qflush='php artisan queue:flush'
alias la5qforget='php artisan queue:forget'
alias la5qlisten='php artisan queue:listen'
alias la5qretry='php artisan queue:retry'
alias la5qsubscribe='php artisan queue:subscribe'
alias la5qwork='php artisan queue:work'

# session
alias la5stable='php artisan session:table'

# view
alias la5vpub='php artisan view:publish'

# misc
alias la5='php artisan'
alias la5changes='php artisan changes'
alias la5down='php artisan down'
alias la5env='php artisan env'
alias la5help='php artisan help'
alias la5list='php artisan list'
alias la5optimize='php artisan optimize'
alias la5routes='php artisan routes'
alias la5serve='php artisan serve'
alias la5tail='php artisan tail'
alias la5tinker='php artisan tinker'
alias la5up='php artisan up'
alias la5work='php artisan workbench'