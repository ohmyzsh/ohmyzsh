# Copies the contents of a given file to the system or X Windows clipboard
#
# Usage: copyfile <file>
function copyfile {
  emulate -L zsh

  clipcopy "${1-}" || {
    echo "Usage: copyfile <file>"
    return 1
  }

  echo ${(%):-"%B${1:-/dev/stdin}%b copied to clipboard."}
}
