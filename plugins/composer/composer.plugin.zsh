# ------------------------------------------------------------------------------
#          FILE:  composer.plugin.zsh
#   DESCRIPTION:  oh-my-zsh composer plugin file.
#        AUTHOR:  Daniel Gomes (me@danielcsgomes.com)
#       VERSION:  1.0.0
# ------------------------------------------------------------------------------

# Composer basic command completion
_composer_get_command_list () {
    $_comp_command1 --no-ansi 2>/dev/null | sed "1,/Available commands/d" | awk '/^[ \t]*[a-z]+/ { print $1 }'
}

_composer_get_required_list () {
    $_comp_command1 show -s --no-ansi 2>/dev/null | sed '1,/requires/d' | awk 'NF > 0 && !/^requires \(dev\)/{ print $1 }'
}

FOUND_COMPOSER=0
composerdirs=("$HOME/.composer" "$HOME/.config/composer")

for composerdir in "${composerdirs[@]}" ; do
    if [ -d $composerdir/vendor/bin -a $FOUND_COMPOSER -eq 0 ] ; then
        FOUND_COMPOSER=1
        
        # Add Composer's global binaries to PATH
        export PATH=${composerdir}/vendor/bin:$PATH
    fi
done
unset composerdir

_composer () {
  local curcontext="$curcontext" state line
  typeset -A opt_args
  _arguments \
    '1: :->command'\
    '*: :->args'

  case $state in
    command)
      compadd $(_composer_get_command_list)
      ;;
    *)
      compadd $(_composer_get_required_list)
      ;;
  esac
}

compdef _composer composer
compdef _composer composer.phar

# Aliases
alias c='composer'
alias csu='composer self-update'
alias cu='composer update'
alias cr='composer require'
alias crm='composer remove'
alias ci='composer install'
alias ccp='composer create-project'
alias cdu='composer dump-autoload'
alias cdo='composer dump-autoload --optimize-autoloader'
alias cgu='composer global update'
alias cgr='composer global require'
alias cgrm='composer global remove'

# install composer in the current directory
alias cget='curl -s https://getcomposer.org/installer | php'
