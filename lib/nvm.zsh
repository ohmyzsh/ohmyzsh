# get the node.js version
function nvm_prompt_info() {
  if [[ "$(command -v nvm)" != "nvm" || -z $(echo $PATH | grep "$HOME/.nvm") ]];
    then return
  fi

  local nvm_prompt
  nvm_prompt=$(node -v 2>/dev/null)
  [[ "${nvm_prompt}x" == "x" ]] && return
  nvm_prompt=${nvm_prompt:1}
  echo "${ZSH_THEME_NVM_PROMPT_PREFIX}${nvm_prompt}${ZSH_THEME_NVM_PROMPT_SUFFIX}"
}
