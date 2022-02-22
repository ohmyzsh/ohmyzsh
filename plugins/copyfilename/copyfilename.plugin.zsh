# Copies the absolute path of a given file to the system or X Windows clipboard
#
# copyfilename <file>
function copyfilename {
  emulate -L zsh
  print -n `realpath "$1"` | clipcopy
}
