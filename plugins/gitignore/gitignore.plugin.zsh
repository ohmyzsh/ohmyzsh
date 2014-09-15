function gi() { curl https://www.gitignore.io/api/$@ ;}

_gitignireio_get_command_list() {
  curl -s https://www.gitignore.io/api/list | tr "," "\n"
}

_gitignireio () {
  compset -P '*,'
  compadd -S '' `_gitignireio_get_command_list`
}

compdef _gitignireio gi
