print -Pru2 -- \
  '%F{yellow}[oh-my-zsh] The %Blaravel4%b plugin is deprecated.' \
  'Use %Blaravel%b instead.%f'

source "${0:A:h:h}/laravel/laravel.plugin.zsh"

# Keep compatibility aliases scoped to users of this legacy plugin.
zstyle -s ':omz:plugins:laravel' php _omz_laravel_php || _omz_laravel_php=php
alias la4="$_omz_laravel_php artisan"
alias la4dump="$_omz_laravel_php artisan dump-autoload"
alias la4cache="$_omz_laravel_php artisan cache:clear"
alias la4routes="$_omz_laravel_php artisan routes"
unset _omz_laravel_php

compdef _artisan la4
