# ------------------------------------------------------------------------------
#          FILE:  composer.plugin.zsh
#   DESCRIPTION:  oh-my-zsh composer plugin file.
#        AUTHOR:  Daniel Gomes (me@danielcsgomes.com)
#       VERSION:  1.0.0
# ------------------------------------------------------------------------------

# Composer basic command completion
_composer_get_command_list () {
	composer --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }'
}

_composer () {
  if [ -f composer.json ]; then
    compadd `_composer_get_command_list`
  else
    compadd create-project init search selfupdate show
  fi
}

compdef _composer composer

# Aliases
alias c='composer'
alias csu='composer self-update'
alias cu='composer update'
alias ci='composer install'
alias ccp='composer create-project'

# install composer in the current directory
alias cget='curl -s https://getcomposer.org/installer | php'
