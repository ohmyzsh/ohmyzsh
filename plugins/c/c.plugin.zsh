# Quickly access your ~/code directory
#  Setting $CODE_HOME will use that instead of ~/code
function c(){
  local code_path=${CODE_HOME}

  if [[ "$code_path" == ""  ]]; then
    code_path="$HOME/code"
  fi

  if [ -d "$code_path/$1" ]; then
    cd "$code_path/$1"
  fi
}
