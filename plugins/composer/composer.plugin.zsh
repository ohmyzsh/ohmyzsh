<<<<<<< HEAD
# ------------------------------------------------------------------------------
#          FILE:  composer.plugin.zsh
#   DESCRIPTION:  oh-my-zsh composer plugin file.
#        AUTHOR:  Daniel Gomes (me@danielcsgomes.com)
#       VERSION:  1.0.0
# ------------------------------------------------------------------------------

# Composer basic command completion
_composer_get_command_list () {
    $_comp_command1 --no-ansi | sed "1,/Available commands/d" | awk '/^[ \t]*[a-z]+/ { print $1 }'
}

_composer_get_required_list () {
    $_comp_command1 show -s --no-ansi | sed '1,/requires/d' | awk 'NF > 0 && !/^requires \(dev\)/{ print $1 }'
}

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
alias ci='composer install'
alias ccp='composer create-project'
alias cdu='composer dump-autoload'
alias cgu='composer global update'
alias cgr='composer global require'

# install composer in the current directory
alias cget='curl -s https://getcomposer.org/installer | php'

# Add Composer's global binaries to PATH
export PATH=$PATH:~/.composer/vendor/bin
=======
## Basic Composer command completion
# Since Zsh 5.7, an improved composer command completion is provided
if ! is-at-least 5.7; then
  _composer () {
    local curcontext="$curcontext" state line
    typeset -A opt_args
    _arguments '*:: :->subcmds'

    if (( CURRENT == 1 )) || ( (( CURRENT == 2 )) && [[ "$words[1]" = "global" ]] ); then
      # Command list
      local -a subcmds
      subcmds=("${(@f)"$($_comp_command1 --no-ansi 2>/dev/null | awk '
        /Available commands/{ r=1 }
        r == 1 && /^[ \t]*[a-z]+/{
          gsub(/^[ \t]+/, "")
          gsub(/  +/, ":")
          print $0
        }
      ')"}")
      _describe -t commands 'composer command' subcmds
    else
      # Required list
      compadd $($_comp_command1 show -s --no-ansi 2>/dev/null \
        | sed '1,/requires/d' \
        | awk 'NF > 0 && !/^requires \(dev\)/{ print $1 }')
    fi
  }

  compdef _composer composer
  compdef _composer composer.phar
fi


## Aliases
alias c='composer'
alias ccp='composer create-project'
alias cdo='composer dump-autoload -o'
alias cdu='composer dump-autoload'
alias cget='curl -s https://getcomposer.org/installer | php'
alias cgr='composer global require'
alias cgrm='composer global remove'
alias cgu='composer global update'
alias ci='composer install'
alias co='composer outdated'
alias cod='composer outdated --direct'
alias cr='composer require'
alias crm='composer remove'
alias cs='composer show'
alias csu='composer self-update'
alias cu='composer update'
alias cuh='composer update --working-dir=$(composer config -g home)'


## If Composer not found, try to add known directories to $PATH
if (( ! $+commands[composer] )); then
  [[ -d "$HOME/.composer/vendor/bin" ]] && export PATH="$PATH:$HOME/.composer/vendor/bin"
  [[ -d "$HOME/.config/composer/vendor/bin" ]] && export PATH="$PATH:$HOME/.config/composer/vendor/bin"

  # If still not found, don't do the rest of the script
  (( $+commands[composer] )) || return 0
fi


## Add Composer's global binaries to PATH
autoload -Uz _store_cache _retrieve_cache _cache_invalid
_retrieve_cache composer

if [[ -z $__composer_bin_dir ]]; then
  __composer_bin_dir=$(composer global config bin-dir --absolute 2>/dev/null)
  _store_cache composer __composer_bin_dir
fi

# Add Composer's global binaries to PATH
export PATH="$PATH:$__composer_bin_dir"

unset __composer_bin_dir
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
