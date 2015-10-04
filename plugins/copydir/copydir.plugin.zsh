# Copies the pathname of the current directory to the system or X Windows clipboard
function copydir {
  emulate -L zsh
  print -n $PWD | clipcopy
}
