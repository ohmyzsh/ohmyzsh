zle-line-init() {
  re-type-on-error
  return 0
}

re-type-on-error() {
  local last_command_exit_code=${?}
  readonly last_command_exit_code
  if [ ${last_command_exit_code} != 0 ]; then
    # disclaimer
    [ "${ZSH_RETYPE_ON_ERROR_SHOW_DISCLAIMER}" = true ] && 
      echo -n "(re-typing last command as exit code " &&
      echo "${last_command_exit_code} was non-zero)"
    
    # populating exit code into $? variable so that 
    # it does not get obfuscated by this plugin
    (exit ${last_command_exit_code}) 

    # re-type failed command
    zle up-history
  fi
  return 0
}

ZSH_RETYPE_ON_ERROR_SHOW_DISCLAIMER=\
"${ZSH_RETYPE_ON_ERROR_SHOW_DISCLAIMER:-true}"

zle -N re-type-on-error
