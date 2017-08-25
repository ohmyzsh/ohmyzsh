#  Completion script for joe. You need to install joe first. See https://github.com/karan/joe
#  License: MIT License
#  Author: ChenPeng <rojazz1999@gmail.com>

function _joe_completion() {
  local -a _1st_arguments
  _1st_arguments=(
     "list:list all available files"
     "update:update all available gitignore files"
     "generate:generate gitignore files"
     "help:Shows a list of commands or help for one command"
  )
  local label_subcommand="joe subcommand"
  if (( CURRENT == 2 )); then
      _describe -t commands "$label_subcommand" _1st_arguments
      return 0
  fi

  case ${words[2]} in
    generate)
      _values -s ',' 'generate' `joe ls | sed -n "2p" | sed "s/,//g"`
  esac
}

compdef _joe_completion joe
