if [ $commands[fasd] ]; then # check if fasd is installed
  eval "$(fasd --init auto)"
  alias v='f -e vim'
  alias o='a -e open'
fi

