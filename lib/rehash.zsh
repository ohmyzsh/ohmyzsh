# auto rehash
_force_rehash(){
    (( CURRENT == 1)) && rehash
    return 1 # because we didn't really complete anything
}

zstyle ':completion:::::' completer _force_rehash _complete _approximate

