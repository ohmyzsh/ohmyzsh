# get the name of the ruby version
function rvm_prompt_info() {
  [ -f $HOME/.rvm/bin/rvm-prompt ] || return
  local rvm_prompt
  rvm_prompt=$($HOME/.rvm/bin/rvm-prompt ${ZSH_THEME_RVM_PROMPT_OPTIONS} 2>/dev/null)
  [[ "${rvm_prompt}x" == "x" ]] && return
  echo "${ZSH_THEME_RVM_PROMPT_PREFIX:=(}${rvm_prompt}${ZSH_THEME_RVM_PROMPT_SUFFIX:=)}"
}

# Bugfix: prompt displays the current directory as "~rvm_rvmrc_cwd"
# http://beginrescueend.com/integration/zsh/
if [[ -s $HOME/.rvm/scripts/rvm ]]; then
    unsetopt auto_name_dirs

    source $HOME/.rvm/scripts/rvm
fi

# If you are using oh-my-zsh and you see something like this error:
# pwd:4: too many arguments
# This is caused by an alias and due to the sh style sourcing of a
# script using the '.' operator instead of 'source'.
# So, go to .oh-my-zsh/lib/aliases.zsh file and uncomment the alias line:
# to "."
