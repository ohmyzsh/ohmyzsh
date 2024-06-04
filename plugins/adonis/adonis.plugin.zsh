# Adonis Plugin

# This plugin provide autocompletion and aliases for adonis
# Adonis : https://adonisjs.com/

# Author: Dimensi0n | Erwan ROUSSEL, jonaselan | Jonas Elan

_adonis() {
  compadd `adonis | cut -d " " -f 3 |  sed -E "s/.\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | tail -n+7 | sed '/^\s*$/d'`
}

compdef _adonis adonis

# Development
alias ads='adonis serve --dev'
alias adrepl='adonis repl'
alias adinstall='adonis install'
alias adt='adonis test'
alias adaddon='adonis addon'

# Migration
alias admt='adonis migration:run'
alias admtrt='adonis migration:reset'
alias admtrf='adonis migration:refresh'
alias admtrfs='adonis migration:refresh --seed'
alias admtr='adonis migration:rollback'
alias admts='adonis migration:status'

# Makers
alias admcm='adonis make:command'
alias admc='adonis make:controller'
alias admh='adonis make:ehandler'
alias adme='adonis make:exception'
alias admhk='adonis make:hook'
alias adml='adonis make:listener'
alias admmw='adonis make:middleware'
alias admmt='adonis make:migration'
alias admm='adonis make:model'
alias admp='adonis make:provider'
alias adms='adonis make:seed'
alias admt='adonis make:test'
alias admtr='adonis make:trait'
alias admv='adonis make:validator'
alias admvw='adonis make:view'


# Route
alias adroute='adonis route:list' 
