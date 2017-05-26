SCRIPT_PATH=${0:a:h}
NODE_MODULES_PATH=""

# Removes applied path from PATH.
function remove_from_path {
  PATH=${PATH/":$1"/}
  PATH=${PATH/"$1:"/}
}

# Checks if given string is found in PATH.
function is_on_path {
  if [[ "$1" ]]; then
    echo $PATH | grep "$1" >/dev/null
  else
    return 1
  fi
}

chpwd_handler() {
  nearest_found_nm=`/usr/bin/env python $SCRIPT_PATH/path_check.py $PWD`

  if [[ "$nearest_found_nm" ]] && is_on_path "$nearest_found_nm/node_modules/.bin"; then
    return
  fi

  if [[ "$NODE_MODULES_PATH" ]]; then
    remove_from_path "$NODE_MODULES_PATH/node_modules/.bin"
    export NODE_MODULES_PATH=""
  fi

  if [[ "$nearest_found_nm" ]]; then
    echo "\033[1;34mFound node_modules in $nearest_found_nm, adding to path\033[0m"
    PATH="$PATH:$nearest_found_nm/node_modules/.bin"
    NODE_MODULES_PATH="$nearest_found_nm"
  fi
}

chpwd_functions=(${chpwd_functions[@]} "chpwd_handler")
chpwd_handler
