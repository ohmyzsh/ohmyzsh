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
alias csu='composer self-update'
alias cu='composer update'


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
