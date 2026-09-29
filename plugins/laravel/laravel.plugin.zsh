#!zsh
# Command used to run artisan, e.g. `herd php` or `php8.4` (default: `php`)
zstyle -s ':omz:plugins:laravel' php _omz_laravel_php || _omz_laravel_php=php

alias artisan="$_omz_laravel_php artisan"
alias bob="$_omz_laravel_php artisan bob::build"

# Development
alias pas="$_omz_laravel_php artisan serve"
alias pad="$_omz_laravel_php artisan dev"
alias pats="$_omz_laravel_php artisan test"

# Database
alias pam="$_omz_laravel_php artisan migrate"
alias pamf="$_omz_laravel_php artisan migrate:fresh"
alias pamfs="$_omz_laravel_php artisan migrate:fresh --seed"
alias pamr="$_omz_laravel_php artisan migrate:rollback"
alias pads="$_omz_laravel_php artisan db:seed"
alias padw="$_omz_laravel_php artisan db:wipe"

# Makers
alias pamm="$_omz_laravel_php artisan make:model"
alias pamc="$_omz_laravel_php artisan make:controller"
alias pams="$_omz_laravel_php artisan make:seeder"
alias pamt="$_omz_laravel_php artisan make:test"
alias pamfa="$_omz_laravel_php artisan make:factory"
alias pamp="$_omz_laravel_php artisan make:policy"
alias pame="$_omz_laravel_php artisan make:event"
alias pamj="$_omz_laravel_php artisan make:job"
alias paml="$_omz_laravel_php artisan make:listener"
alias pamn="$_omz_laravel_php artisan make:notification"
alias pampp="$_omz_laravel_php artisan make:provider"
alias pamcl="$_omz_laravel_php artisan make:class"
alias pamen="$_omz_laravel_php artisan make:enum"
alias pami="$_omz_laravel_php artisan make:interface"
alias pamtr="$_omz_laravel_php artisan make:trait"
alias pamv="$_omz_laravel_php artisan make:view"
alias pammig="$_omz_laravel_php artisan make:migration"


# Clears
alias pacac="$_omz_laravel_php artisan cache:clear"
alias pacoc="$_omz_laravel_php artisan config:clear"
alias pavic="$_omz_laravel_php artisan view:clear"
alias paroc="$_omz_laravel_php artisan route:clear"
alias paopc="$_omz_laravel_php artisan optimize:clear"

# queues
alias paqf="$_omz_laravel_php artisan queue:failed"
alias paqft="$_omz_laravel_php artisan queue:failed-table"
alias paql="$_omz_laravel_php artisan queue:listen"
alias paqr="$_omz_laravel_php artisan queue:retry"
alias paqt="$_omz_laravel_php artisan queue:table"
alias paqw="$_omz_laravel_php artisan queue:work"

unset _omz_laravel_php
