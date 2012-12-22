# Upload files to flag.io
upload() {
  if [ $# -lt 1 ]; then
    printf 'usage: upload <file> [<file> ...]\n'
    return 1
  fi

  for path in $@; do
    if [ -f "$path" ]; then
      curl -sT "$path" flag.io | egrep -v '^#'
    else
      printf 'File not found: %s\n' "$path"
    fi
  done
}
