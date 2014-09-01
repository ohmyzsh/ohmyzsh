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

_composer_get_required_list () {
    composer show -s --no-ansi | sed '1,/requires/d' | awk 'NF > 0 && !/^requires \(dev\)/{ print $1 }'
}

_composer () {
  local curcontext="$curcontext" state line
  typeset -A opt_args
  _arguments \
    '1: :->command'\
    '*: :->args'
  if [ -f composer.json ]; then
    case $state in
      command)
        compadd `_composer_get_command_list`
        ;;
      *)
        compadd `_composer_get_required_list`
        ;;
    esac
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
alias cdu='composer dump-autoload'

# install composer in the current directory
alias cget='curl -s https://getcomposer.org/installer | php'

# Add Composer's global binaries to PATH
export PATH=$PATH:~/.composer/vendor/bin
