# Copies the path of given directory or file to the system or X Windows clipboard.
# Copy current directory if no parameter.
function copypath {
  emulate -L zsh
  if [[ -n "$1" ]]; then
    print -n $PWD/$1 | clipcopy
  else
    print -n $PWD | clipcopy
  fi
}
