function rm () {
  local files
  local trash=~/.Trash/
  for files in "$@"; do
    # ignore any arguments
    if [[ "$files" = -* ]]; then :
    else
      local dst=${files##*/}
      # append the time if necessary
      while [ -e $trash$dst ]; do
        dst=$dst_$(date +%H-%M-%S)
      done
      /bin/mv $files $trash$dst
    fi
  done
}
