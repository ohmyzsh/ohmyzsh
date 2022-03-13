#!/bin/zsh

# path - PATH variable operator
#
# varsion: 0.2
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
    local dir="$PWD"
    if [ ! -z "$2" ]; then
      dir="$(realpath "$2")"
      if [ ! -d "$dir" ]; then
        echo "path: '$dir' is not a valid directory." >&2
        return 1
      fi
    fi

    if [ -z $3 ]; then
      path=("$dir" "${path[@]}")
    elif [ $3 == '-' ]; then
      path=( "${path[@]}" "$dir")
    else
      path=("${path[@]:0:$3}" "$dir" "${path[@]:$3}")
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
    local dir="$PWD"
    if [ ! -z "$2" ]; then
      dir="$(realpath "$2")"
    fi

    if path add "$2"; then
      echo 'export PATH="'"$dir"':$PATH"' >> ~/.zshrc.path
    fi

  else
    _bold() {
      echo -e "\e[1;33m$1\e[0m"
    }

    cat <<EOF
PATH variable operator; v0.2 (2022-03-13)

Usage: 
  path add [DIR] [INDEX]  
  path rm  [INDEX]
  path set [DIR]

Command:

  $(_bold add)    Add PATH
    - DIR     target directory. (default=.)
    - INDEX   set insertion position. (default=0; i.e. head; '-' indicate tail)

  $(_bold rm)     Remove PATH 
    - INDEX   index of item. (default=0)

  $(_bold set)    Permanency set PATH
    - DIR     target directory. (default=.)

    Like \`path add DIR\`, then write to ~/.zshrc.path for next init.
    Load it additionally if plugin is offed. 
EOF
  fi

  export PATH
}

