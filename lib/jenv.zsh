# get the java version
function jenv_prompt_info() {
  [ -f $HOME/.jenv/version ] || return
  local jenv_prompt
  jenv_prompt=$(jenv version-name 2>/dev/null)
  [[ "${jenv_prompt}x" == "x" ]] && return
  jenv_prompt=${jenv_prompt}
  echo "${ZSH_THEME_NVM_PROMPT_PREFIX}${jenv_prompt}${ZSH_THEME_NVM_PROMPT_SUFFIX}"
}