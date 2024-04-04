function _tasko_print_help() {
  echo
  echo "Usage: tasko {TASK} {ROW}"
  echo
}

function tasko () {
  if [[ $# -ne 2 ]]; then
    echo 'Error: Too many/few arguments, expecting two.' >&2
    _tasko_print_help
    return 1
  fi

  local annotation_desc=$(task _get $1.annotations.$2.description 2>/dev/null)
  if [[ $? -ne 0 ]]; then
    echo "Error: Task or row not found." >&2
    return 1
  fi

  if [[ $annotation_desc == "" ]]; then
    echo "Error: No text found" >&2
    return 1
  fi

  echo "Open $annotation_desc? [y/n]"
  read answer
  if [[ $answer == y* ]] || [[ $answer == Y* ]]; then
    if [[ $(uname -s) == "Linux" ]]; then
      xdg-open $annotation_desc
      return 0
    else
      open $annotation_desc
      return 0
    fi
    return 1
  fi
  return 0
}
