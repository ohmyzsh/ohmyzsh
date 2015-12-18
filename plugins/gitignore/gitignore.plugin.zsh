<<<<<<< HEAD
function gi() { curl http://gitignore.io/api/$@ ;}

_gitignireio_get_command_list() {
  curl -s http://gitignore.io/api/list | tr "," "\n"
=======
function gi() { curl -sL https://www.gitignore.io/api/$@ ;}

_gitignoreio_get_command_list() {
  curl -sL https://www.gitignore.io/api/list | tr "," "\n"
>>>>>>> upstream/master
}

_gitignoreio () {
  compset -P '*,'
  compadd -S '' `_gitignoreio_get_command_list`
}

<<<<<<< HEAD
compdef _gitignireio gi
=======
compdef _gitignoreio gi
>>>>>>> upstream/master
