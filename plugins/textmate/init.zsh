# Functions
function tm() {
  if [[ -z "$1" ]]; then
    mate .
  else
    ( [[ -d "$1" ]] && cd "$1" && mate . )
  fi
}

