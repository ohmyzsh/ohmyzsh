function virtualenv_prompt_info(){
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path ]]; then
    local virtualenv_name=`basename $virtualenv_path`
    printf "%s[%s] " "%{${fg[yellow]}%}" $virtualenv_name
  fi
}

export VIRTUAL_ENV_DISABLE_PROMPT=1
