#!zsh
alias artisan='php artisan'
alias bob='php artisan bob::build'

# Development
alias pas='php artisan serve'
alias pats='php artisan test'

# Database
alias pam='php artisan migrate'
alias pamf='php artisan migrate:fresh'
alias pamfs='php artisan migrate:fresh --seed'
alias pamr='php artisan migrate:rollback'
alias pads='php artisan db:seed'
alias padw='php artisan db:wipe'

# Makers
alias pamm='php artisan make:model'
alias pamc='php artisan make:controller'
alias pams='php artisan make:seeder'
alias pamt='php artisan make:test'
alias pamfa='php artisan make:factory'
alias pamp='php artisan make:policy'
alias pame='php artisan make:event'
alias pamj='php artisan make:job'
alias paml='php artisan make:listener'
alias pamn='php artisan make:notification'
alias pampp='php artisan make:provider'
alias pamcl='php artisan make:class'
alias pamen='php artisan make:enum'
alias pami='php artisan make:interface'
alias pamtr='php artisan make:trait'


# Clears
alias pacac='php artisan cache:clear'
alias pacoc='php artisan config:clear'
alias pavic='php artisan view:clear'
alias paroc='php artisan route:clear'
alias paopc='php artisan optimize:clear'

# queues
alias paqf='php artisan queue:failed'
alias paqft='php artisan queue:failed-table'
alias paql='php artisan queue:listen'
alias paqr='php artisan queue:retry'
alias paqt='php artisan queue:table'
alias paqw='php artisan queue:work'

# Nwidart Modules
alias pmmake='php artisan module:make'
alias pmlist='php artisan module:list'
alias pmmigrate='php artisan module:migrate'
alias pmrollback='php artisan module:migrate-rollback'
alias pmrefresh='php artisan module:migrate-refresh'
alias pmreset='php artisan module:migrate-reset'
alias pmseed='php artisan module:seed'
alias pmenable='php artisan module:enable'
alias pmdisable='php artisan module:disable'

# Nwidart Modules Generator Commands
alias pmcommand='php artisan module:make-command'
alias pmmigration='php artisan module:make-migration'
alias pmseed='php artisan module:make-seed'
alias pmcontroller='php artisan module:make-controller'
alias pmmodel='php artisan module:make-model'
alias pmprovider='php artisan module:make-provider'
alias pmmiddleware='php artisan module:make-middleware'
alias pmmail='php artisan module:make-mail'
alias pmnotification='php artisan module:make-notification'
alias pmlistener='php artisan module:make-listener'
alias pmrequest='php artisan module:make-request'
alias pmevent='php artisan module:make-event'
alias pmjob='php artisan module:make-job'
alias pmrprovider='php artisan module:route-provider'
alias pmfactory='php artisan module:make-factory'
alias pmpolicy='php artisan module:make-policy'
alias pmrule='php artisan module:make-rule'
alias pmresource='php artisan module:make-resource'
alias pmtest='php artisan module:make-test'
