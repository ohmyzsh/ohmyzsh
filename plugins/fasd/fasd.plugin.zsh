if [ $commands[fasd] ]; then # check if fasd is installed
  eval "$(fasd --init auto)"
  alias v='f -e vim'

  if [[ $('uname') == 'Linux' ]] && [ $commands[xdg-open] ]; then
    alias o='a -e xdg-open'
  elif [[ $('uname') == 'Darwin' ]]; then
    alias o='a -e open'
  fi
fi