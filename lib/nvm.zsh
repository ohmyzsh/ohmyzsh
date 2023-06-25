# get the nvm-controlled node.js version
function nvm_prompt_info() {
  which nvm &>/dev/null || return
  local package_json="package.json"
  test -f ${package_json} &>/dev/null || return
  local nvm_prompt=${$(nvm current)#v}
  local nvm_short_version=${nvm_prompt:0:2}
  if [ "${ZSH_THEME_NVM_PROMPT_SHORT}" = true ]; 
  then 
    echo "${ZSH_THEME_NVM_PROMPT_PREFIX}${nvm_short_version:gs/%/%%}${ZSH_THEME_NVM_PROMPT_SUFFIX}"
  else 
    echo "${ZSH_THEME_NVM_PROMPT_PREFIX}${nvm_prompt:gs/%/%%}${ZSH_THEME_NVM_PROMPT_SUFFIX}"
  fi
}
