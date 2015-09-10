# get the nvm-controlled node.js version
function nvm_prompt_info() {
  local nvm_prompt
  which nvm &>/dev/null || return
  nvm_prompt=$(nvm current)
  nvm_prompt=${nvm_prompt#v}
  echo "${ZSH_THEME_NVM_PROMPT_PREFIX}${nvm_prompt}${ZSH_THEME_NVM_PROMPT_SUFFIX}"
}
