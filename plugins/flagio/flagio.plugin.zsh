# Upload files to flag.io
upload() {
  local file

  if [ $# -lt 1 ]; then
    printf 'usage: upload <file> [<file> ...]\n'
    return 1
  fi

  for file in $@; do
    if [ -f "$file" ]; then
      curl -sT "$file" flag.io | egrep -v '^#'
    else
      printf 'File not found: %s\n' "$file"
    fi
  done
}
