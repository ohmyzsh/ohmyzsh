# ------------------------------------------------------------------------------
# FILE: n98-magerun.plugin.zsh
# DESCRIPTION: oh-my-zsh n98-magerun plugin file. Adapted from composer plugin
# AUTHOR: Andrew Dwyer (andrewrdwyer at gmail dot com)
# AUTHOR: Jisse Reitsma (jisse at yireo dot com)
# VERSION: 1.1.0
# ------------------------------------------------------------------------------

# n98-magerun basic command completion
_n98_magerun_get_command_list () {
  $_comp_command1 --no-ansi | sed "1,/Available commands/d" | awk '/^ +[a-z\-:]+/ { print $1 }'
}


_n98_magerun () {
  _arguments '1: :->command' '*:optional arg:_files'

  case $state in
    command)
      compadd $(_n98_magerun_get_command_list)
      ;;
    *)
  esac
}

compdef _n98_magerun n98-magerun.phar
compdef _n98_magerun n98-magerun
compdef _n98_magerun n98-magerun2.phar
compdef _n98_magerun n98-magerun2

# Aliases
alias n98='n98-magerun.phar'
alias mage='n98-magerun.phar'
alias magerun='n98-magerun.phar'

alias n98-2='n98-magerun2.phar'
alias mage2='n98-magerun2.phar'
alias magerun2='n98-magerun2.phar'

# Install n98-magerun into the current directory
alias mage-get='wget https://files.magerun.net/n98-magerun.phar'
alias mage2-get='wget https://files.magerun.net/n98-magerun2.phar'
