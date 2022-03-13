#!/bin/zsh

# path - PATH variable operator
#
# varsion: 0.1
# date: 2022-03-13 


if [ -f ~/.zshrc.path ]; then
  source ~/.zshrc.path
fi

function path() {
  #local path=(${(s/:/)PATH})

  if [ -z $1 ]; then
    local i=0
    for v in $path; do
      echo -e "\e[3;36m$i\e[0m"  $v
      (( i++ ))
    done

  elif [ $1 == 'add' ]; then
    if [ -z $2 ]; then
      path=("$PWD" "${path[@]}")
    elif [ $2 == '-' ]; then
      path=( "${path[@]}" "$PWD")
    else
      path=("${path[@]:0:$2}" "$PWD" "${path[@]:$2}")
    fi 

  elif [ $1 == 'rm' ]; then
    if [ -z $2 ]; then
      shift path
    else
      local i
      ((i = $2 + 1))
      path=("${path[@]:0:$2}" "${path[@]:$i}")
    fi

  elif [ $1 == 'set' ]; then
    path=("$PWD" "${path[@]}") 
    echo 'export PATH="'$PWD':$PATH"' >> ~/.zshrc.path

  else
    cat <<'EOF'
PATH variable operator; v0.1 (2022-03-13)

Usage: 
  path add [INDEX]     add PWD to PATH
  path rm  [INDEX]     remove item from PATH
  path set [DIR=.]     add dir to PATH, and write '~/.zshrc.path' 

Note:
  * Param [INDEX] default 0, '-' as count of items.
  * '-/.zshrc.paths' is auto load at plugin initial, load it additionally if plugin is offed. 
EOF

  fi

  export PATH
}


