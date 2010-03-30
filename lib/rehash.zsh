#-*- sh -*-


## will rehash 
_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1      # Because we didn't really complete anything
}

zstyle ':completion:::::' completer _force_rehash _complete _approximate