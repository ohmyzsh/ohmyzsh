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

_composer () {
    local curcontext="$curcontext" state line
    typeset -A opt_args
    _arguments \
        '*:: :->subcmds'

    if (( CURRENT == 1 )) || ( ((CURRENT == 2)) && [ "$words[1]" = "global" ] ) ; then
        compadd $(_composer_get_command_list)
    else
        compadd $(_composer_get_required_list)
    fi
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
alias cdo='composer dump-autoload -o'
alias cgu='composer global update'
alias cgr='composer global require'
alias cgrm='composer global remove'

# install composer in the current directory
alias cget='curl -s https://getcomposer.org/installer | php'

# Add Composer's global binaries to PATH, using Composer if available.
if (( $+commands[composer] )); then
  export PATH=$PATH:$(composer global config bin-dir --absolute 2>/dev/null)
else
  [ -d $HOME/.composer/vendor/bin ] && export PATH=$PATH:$HOME/.composer/vendor/bin
  [ -d $HOME/.config/composer/vendor/bin ] && export PATH=$PATH:$HOME/.config/composer/vendor/bin
fi
