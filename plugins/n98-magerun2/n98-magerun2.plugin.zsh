# ------------------------------------------------------------------------------
# FILE: n98-magerun2.plugin.zsh
# DESCRIPTION: oh-my-zsh n98-magerun2 plugin file. Adapted from composer plugin 
# AUTHOR: Andrew Dwyer (andrewrdwyer at gmail dot com)
# AUTHOR: Jisse Reitsma (jisse at yireo dot com)
# VERSION: 1.0.0
# ------------------------------------------------------------------------------

# n98-magerun2 basic command completion
_n98_magerun2_get_command_list () {
  $_comp_command1 --no-ansi | sed "1,/Available commands/d" | awk '/^ +[a-z\-:]+/ { print $1 }'
}


_n98_magerun2 () {
  _arguments '1: :->command' '*:optional arg:_files'

  case $state in
    command)
      compadd $(_n98_magerun2_get_command_list)
      ;;
    *)
  esac
}

compdef _n98_magerun2 n98-magerun2.phar
compdef _n98_magerun2 n98-magerun2
compdef _n98_magerun2 magerun2

# Aliases
alias n98-magerun2='n98-magerun2.phar'
alias magerun2='n98-magerun2.phar'
alias mage2='n98-magerun2.phar'
alias mage2fl='n98-magerun2.phar cache:flush'

# Install n98-magerun2 into the current directory
alias mage2-get='wget https://raw.github.com/netz98/n98-magerun2/master/n98-magerun2.phar'
