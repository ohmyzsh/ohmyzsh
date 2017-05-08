#
# Aliases
# (sorted alphabetically)
#

alias ara='arc amend'
alias arb='arc branch'
alias arco='arc cover'
alias arci='arc commit'

alias ard='arc diff'
alias ardnu='arc diff --nounit'
alias ardnupc='arc diff --nounit --plan-changes'
alias ardpc='arc diff --plan-changes'

alias are='arc export'
alias arh='arc help'
alias arl='arc land'
alias arli='arc lint'
alias arls='arc list'
alias arpa='arc patch'

#
# Completion
#

autoload -U +X bashcompinit && bashcompinit

_arc ()
{
  CUR="${COMP_WORDS[COMP_CWORD]}"
  COMPREPLY=()
  OPTS=$(echo | arc shell-complete --current ${COMP_CWORD} -- ${COMP_WORDS[@]})

  if [ $? -ne 0 ]; then
    return $?
  fi

  if [ "$OPTS" = "FILE" ]; then
    COMPREPLY=( $(compgen -f -- ${CUR}) )
    return 0
  fi

  if [ "$OPTS" = "ARGUMENT" ]; then
    return 0
  fi

  COMPREPLY=( $(compgen -W "${OPTS}" -- ${CUR}) )
}
complete -F _arc -o filenames arc
