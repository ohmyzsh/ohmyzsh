#######################################################################
# uvenv is a micro python virtualenv wrapper desired to make life
# easier while working with multiple virtualenvs
#
# It delivers virtualenv_prompt_info function which shows currently
# active virtualenv, and allows to easily switch between others
#
# The one requirement is that virtualenv must be located in
# '.venv' subdirectory of current project. Global virtualenvs
# are not supported at this time
#
# Prompt Extention:
#
# There are variety of possible prompt modifiers:
# uvenv:[None]         - if none virtualenv is activated
# uvenv:[CurrentVenv]  - if there is activated virtualenv
# uvenv:[CurrentVenv|CurrentDirVenv] 
#                      - if there is activated virtualenv but there 
#                        is possibility to switch to another
#
# New commands:
#
# activate    - to activate or switch to another possible virtualenv
#
# cdvenv      - to change directory that corresponds with currently
#               active virtual env
#
# create_venv - to create virtualenv in current directory that
#                meets plugin requirements
#
# New Functionality:
# - auto activate virutal env while directory change leads to one
#   where virtual env is configured, and there is no active virtualenv
#   controlled by: VIRTUAL_ENV_AUTOACTIVATE
#######################################################################
declare -x ZSH_UVENV_COLOR_DARKGREY=`tput setaf 240`
declare -x ZSH_UVENV_COLOR_GREEN=`tput setaf 2`

_get_venv_in_dir()
{
  local iter_path
  local venv_path
  local tmp
  iter_path=${PWD:A}
  while [[ $iter_path != "/" ]]; do
    venv_path=$iter_path/.venv
    venv_path=${venv_path:A}
    if [[ -d $venv_path ]]; then
      echo $venv_path
      return 0
    fi
    tmp=$iter_path/..
    iter_path=${tmp:A}
  done
  echo "None"
  return 1
}

_get_venv_name()
{
  local tmp
  local last_chunk
  tmp=$1
  last_chunk=${tmp:A:t}
  if [[ $last_chunk == ".venv" ]]; then
    tmp=$tmp/..
    echo ${tmp:A:t}
    return 0
  fi
  echo $last_chunk
  return 1
}

virtualenv_prompt_info()
{
  local in_dir_venv
  local active_venv
  in_dir_venv=$(_get_venv_in_dir)
  echo -n "${ZSH_THEME_VIRTUALENV_PREFIX:=venv:[}"
  [[ -n ${VIRTUAL_ENV} ]] \
    && echo -n %{${ZSH_THEME_VIRTUALENV_ACTIVE:=$ZSH_UVENV_COLOR_GREEN%}}\
$(_get_venv_name ${VIRTUAL_ENV})
  echo -n %{`tput sgr0`%}
  [[ -n ${VIRTUAL_ENV+x} ]] \
    && [[ ${VIRTUAL_ENV} != $in_dir_venv ]] \
    && echo -n "${ZSH_THEME_VIRTUALENV_SEPARATOR:=|}"
  echo -n %{${ZSH_THEME_VIRTUALENV_INACTIVE:=$ZSH_UVENV_COLOR_DARKGREY%}}
  [[ ${VIRTUAL_ENV} != $in_dir_venv ]] && echo -n $(_get_venv_name $in_dir_venv)
  echo -n %{`tput sgr0`%}
  echo -n "${ZSH_THEME_VIRTUALENV_SUFFIX:=]}"
}

activate()
{
  local in_dir_venv
  in_dir_venv=$(_get_venv_in_dir)/bin/activate
  [[ -f $in_dir_venv ]] || return
  . $in_dir_venv
}

chpwd()
{
  if (( ${+VIRTUAL_ENV} )); then 
    return
  fi
  [[ -n ${+VIRTUAL_ENV_AUTOACTIVATE+x} ]] \
    && [[ ${VIRTUAL_ENV_AUTOACTIVATE} == 1 ]] && activate
}

create_venv()
{
  local venv_name
  venv_name=${PWD:A:t}
  virtualenv -v .venv "$@"
  chpwd
}

cdvenv()
{
  if (( ${+VIRTUAL_ENV} )); then 
    cd ${VIRTUAL_ENV:A:h}
  fi
  return 1
}

export VIRTUAL_ENV_AUTOACTIVATE=1
export VIRTUAL_ENV_DISABLE_PROMPT=1
