function virtualenv_check() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path ]]; then
    local virtualenv_name=`basename $virtualenv_path`
    printf "%s" $virtualenv_name
  fi
}

function virtualenv_prompt_info() {
  local prefix="$ZSH_THEME_VIRTUALENV_PROMPT_PREFIX"
  local suffix="$ZSH_THEME_VIRTUALENV_PROMPT_SUFFIX"
  if [[ -n $(virtualenv_check) ]]; then
    if [[ -n $prefix ]]; then
      printf "%s%s%s" $prefix $(virtualenv_check) $suffix
    else
      printf "%s[%s] " "%{${fg[yellow]}%}" $(virtualenv_check)
    fi
  fi
}

export VIRTUAL_ENV_DISABLE_PROMPT=1
