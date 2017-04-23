# get the node.js version
function node_prompt_info() {
  local node_prompt
  node_prompt=$(node -v 2>/dev/null)
  [[ "${node_prompt}x" == "x" ]] && return
  node_prompt=${node_prompt:1}
  echo "${ZSH_THEME_NVM_PROMPT_PREFIX}${node_prompt}${ZSH_THEME_NVM_PROMPT_SUFFIX}"
}
