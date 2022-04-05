<<<<<<< HEAD
# get the node.js version
function nvm_prompt_info() {
  [ -f "$HOME/.nvm/nvm.sh" ] || return
  local nvm_prompt
  nvm_prompt=$(node -v 2>/dev/null)
  [[ "${nvm_prompt}x" == "x" ]] && return
  nvm_prompt=${nvm_prompt:1}
  echo "${ZSH_THEME_NVM_PROMPT_PREFIX}${nvm_prompt}${ZSH_THEME_NVM_PROMPT_SUFFIX}"
=======
# get the nvm-controlled node.js version
function nvm_prompt_info() {
  which nvm &>/dev/null || return
  local nvm_prompt=${$(nvm current)#v}
  echo "${ZSH_THEME_NVM_PROMPT_PREFIX}${nvm_prompt:gs/%/%%}${ZSH_THEME_NVM_PROMPT_SUFFIX}"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}
