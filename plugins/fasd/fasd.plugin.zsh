if [ $commands[fasd] ]; then # check if fasd is installed
  fasd_cache="${ZSH_CACHE_DIR}/fasd-init-cache"
  if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
    fasd --init auto >| "$fasd_cache"
  fi
  source "$fasd_cache"
  unset fasd_cache
  alias v='f -e vim'

  if [[ $('uname') == 'Linux' ]] && [ $commands[xdg-open] ]; then
    alias o='a -e xdg-open'
  elif [[ $('uname') == 'Darwin' ]]; then
    alias o='a -e open'
  fi
fi