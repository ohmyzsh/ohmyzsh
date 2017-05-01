# Save dirstack history to .zdirs
# adapted from:
# github.com/grml/grml-etc-core/blob/master/etc/zsh/zshrc#L1547

DIRSTACKSIZE=${DIRSTACKSIZE:-20}
dirstack_file=${dirstack_file:-${HOME}/.zdirs}

if [[ -f ${dirstack_file} ]] && [[ ${#dirstack[*]} -eq 0 ]] ; then
  dirstack=( ${(f)"$(< $dirstack_file)"} )
  # "cd -" won't work after login by just setting $OLDPWD, so
  [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi

chpwd_functions+=(chpwd_dirpersist)
chpwd_dirpersist() {
  if (( $DIRSTACKSIZE <= 0 )) || [[ -z $dirstack_file ]]; then return; fi
  local -ax my_stack
  my_stack=( ${PWD} ${dirstack} )
  builtin print -l ${(u)my_stack} >! ${dirstack_file}
}
