# get the python version
function python_prompt_info() {
  local python_prompt
  python_prompt=$(python -c 'import platform; print(platform.python_version())')
  [[ "${python_prompt}x" == "x" ]] && return
  echo "${ZSH_THEME_PYTHON_PROMPT_PREFIX}${python_prompt}${ZSH_THEME_PYTHON_PROMPT_SUFFIX}"
}
