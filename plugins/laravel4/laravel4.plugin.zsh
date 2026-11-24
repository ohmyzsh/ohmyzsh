print -Pru2 -- \
  '%F{yellow}[oh-my-zsh] The %Blaravel4%b plugin is deprecated.' \
  'Use %Blaravel%b instead.%f'

source "${0:A:h:h}/laravel/laravel.plugin.zsh"
