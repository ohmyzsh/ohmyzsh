# Adonis Plugin

# This plugin provide autocompletion for adonis
# Adonis : https://adonisjs.com/

# Author: Dimensi0n | Erwan ROUSSEL

_adonis() {
  local -a subcmds

  subcmds=(
    'addon:Create a new AdonisJs addon'
    'install:'
    'new'
    'repl'
    'serve'
    'key\\:generate'
    'make\\:command'
    'make\\:controller'
    'make\\:ehandler'
    'make\\:exception'
    'make\\:hook'
    'make\\:listener'
    'make\\:middleware'
    'make\\:migration'
    'make\\:model'
    'make\\:provider'
    'make\\:seed'
    'make\\:trait'
    'make\\:view'
    'route\\:list'
    'run\\:instructions'
  )

  _describe 'adonis' subcmds
}

compdef _adonis adonis