print -Pru2 -- \
  '%F{yellow}[oh-my-zsh] The %Blaravel5%b plugin is deprecated.' \
  'Use %Blaravel%b instead.%f'

source "${0:A:h:h}/laravel/laravel.plugin.zsh"

# Keep compatibility aliases scoped to users of this legacy plugin.
zstyle -s ':omz:plugins:laravel' php _omz_laravel_php || _omz_laravel_php=php
alias la5="$_omz_laravel_php artisan"
alias la5cache="$_omz_laravel_php artisan cache:clear"
alias la5routes="$_omz_laravel_php artisan route:list"
alias la5vendor="$_omz_laravel_php artisan vendor:publish"
unset _omz_laravel_php

compdef _artisan la5
