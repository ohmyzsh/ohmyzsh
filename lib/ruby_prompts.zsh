# get the name of the rvm ruby version
function rvm_prompt_info() {
  [ -f $HOME/.rvm/bin/rvm-prompt ] || return 1
  local rvm_prompt
  rvm_prompt=$(eval "$HOME/.rvm/bin/rvm-prompt $ZSH_THEME_RVM_PROMPT_OPTIONS" 2>/dev/null)
  [[ "${rvm_prompt}x" == "x" ]] && return 1
  echo "${ZSH_THEME_RVM_PROMPT_PREFIX:=(}${rvm_prompt}${ZSH_THEME_RVM_PROMPT_SUFFIX:=)}"
}

# using the chruby and/or rbenv plugins will override
# these with real implementations
function chruby_prompt_info rbenv_prompt_info {
  return 1
}

function ruby_prompt_info() {
  echo $(rvm_prompt_info || rbenv_prompt_info || chruby_prompt_info)
}
