# get the golang version
function go_prompt_info() {
  local go_prompt
  go_prompt=$(go version | awk '{ print substr($3, 3) }')
  [[ "${go_prompt}x" == "x" ]] && return
  echo "${ZSH_THEME_GO_PROMPT_PREFIX}${go_prompt}${ZSH_THEME_GO_PROMPT_SUFFIX}"
}
