# Copies the contents of a given file to the system or X Windows clipboard
#
# Usage: copyfile <file>
function copyfile {
  emulate -L zsh

  if [[ -z "$1" ]]; then
    echo "Usage: copyfile <file>"
    return 1
  fi

  if [[ ! -f "$1" ]]; then
    echo "Error: '$1' is not a valid file."
    return 1
  fi

  clipcopy $1
  echo ${(%):-"%B$1%b copied to clipboard."}
}
