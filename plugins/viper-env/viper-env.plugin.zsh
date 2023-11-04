# Colors based on:
# https://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html#16-colors
export COLOR_BLACK='\033[0;30m'
export COLOR_BRIGHT_BLACK='\u001b[30;1m'
export COLOR_RED='\033[0;31m'
export COLOR_BRIGHT_RED='\u001b[31;1m'
export COLOR_GREEN='\033[0;32m'
export COLOR_BRIGHT_GREEN='\u001b[32;1m'
export COLOR_YELLOW='\033[0;33m'
export COLOR_BRIGHT_YELLOW='\u001b[33;1m'
export COLOR_BLUE='\033[0;34m'
export COLOR_BRIGHT_BLUE='\u001b[34;1m'
export COLOR_VIOLET='\033[0;35m'
export COLOR_BRIGHT_VIOLET='\u001b[35;1m'
export COLOR_CYAN='\033[0;36m'
export COLOR_BRIGHT_CYAN='\u001b[36;1m'
export COLOR_WHITE='\033[0;37m'
export COLOR_NC='\033[0m' # No Color

function activate_env_execution() {  
  local virtualenv_directory=$1
  local d=$2
  local relative_env_path=$3
  local full_virtualenv_directory=$d/$virtualenv_directory

  echo Activating virtual environment ${COLOR_BRIGHT_VIOLET}$relative_env_path${COLOR_NC}
  source $full_virtualenv_directory/bin/activate
}

function get_env_path(){
  echo "$(basename "$1")/$2"
}

function get_envs(){
  local output="$(ls (.*|*)/bin/pip(.x))" &> /dev/null
  local candidate_envs_found
  if [ $? -eq 0 ]; then
    candidate_envs_found=($output)
  else
    candidate_envs_found=()
  fi
  envs_found=()
  for env in "${candidate_envs_found[@]}"
  do
    local env_name="$(dirname $env)"
    ls $env_name/activate &> /dev/null
    if [ $? -eq 0 ]; then
      envs_found+=("$(dirname $env_name)")
    fi
  done
}

function activate_env(){
  local current_dir=$1
  get_envs
  # echo "Envs found: $envs_found"
  if [ ${#envs_found[@]} -gt 0 ]; then
    # Use first found only!
    local env_name="${envs_found[1]}"
    # local env_name="$(dirname "$(dirname $env_to_use)")"
    local relative_activating_env_path="$(get_env_path $current_dir $env_name)"
    activate_env_execution $env_name $current_dir $relative_activating_env_path
  fi  
}

function automatically_activate_python_env() {
  local current_dir="$PWD"
  local env_var="$VIRTUAL_ENV"
  if [[ -z $env_var ]] ; then
    activate_env $current_dir
  else
    parentdir="$(dirname $env_var)"
    if [[ $current_dir/ != $parentdir/* ]] ; then
      local deactivating_relative_env_path="$(realpath --relative-to=$current_dir $env_var)"
      echo Deactivating virtual environment ${COLOR_BRIGHT_VIOLET}$deactivating_relative_env_path${COLOR_NC}
      deactivate
      activate_env $current_dir
    fi
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd automatically_activate_python_env

__viper-env_help () {
  printf "Description:
  ${COLOR_BRIGHT_BLACK}Automatically activates and deactivates python virtualenv upon cd in and out.${COLOR_NC}

"
  printf "Dependencies:
  ${COLOR_BRIGHT_BLACK}- zsh
  - python${COLOR_NC}

"
  printf "Example usage:
  ${COLOR_BRIGHT_BLACK}# Create virtual environment${COLOR_NC}
  ${COLOR_GREEN}python${COLOR_NC} -m env .env
  ${COLOR_BRIGHT_BLACK}# Save current dir${COLOR_NC}
  current_dir=${COLOR_VIOLET}\$(${COLOR_GREEN}basename ${COLOR_YELLOW}"${COLOR_NC}\$PWD${COLOR_YELLOW}"${COLOR_VIOLET})${COLOR_NC}
  ${COLOR_BRIGHT_BLACK}# Exit current directory${COLOR_NC}
  ${COLOR_GREEN}cd${COLOR_NC} ..
  ${COLOR_BRIGHT_BLACK}# Reenter it${COLOR_NC}
  ${COLOR_GREEN}cd${COLOR_NC} \$current_dir
"
}

viper-env_runner() {
  if [[ $@ == "help" || $@ == "h" ]]; then 
    __viper-env_help
  #elif [[ $@ == "something" || $@ == "alias" ]]; then 
  fi
}

alias viper-env='viper-env_runner'
