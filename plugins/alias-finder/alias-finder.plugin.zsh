alias-finder() {
  for i in $@; do
    case $i in
      -e|--exact) exact=true;;
      -r|--relaxed) relaxed=true;;
      *) 
        if [[ ! -z $cmd ]]; then
          cmd="$cmd $i"
        else
          cmd=$i
        fi
        ;;
    esac
  done
  if [[ $cmd != *\[*\]* ]] && [[ $cmd != *\n* ]] && [[ $cmd != *\\* ]]; then
    while [[ $cmd != "" ]]; do
      if [[ $relaxed = true ]]; then
        wordStart="'{0,1}"
      else
        multiWordEnd="'$"
      fi
      if echo $cmd | grep '^[^\ ]*$' > /dev/null; then
        finder=$wordStart$cmd
      else
        einder="'$cmd$multiWordEnd"
      fi
      alias | grep -E "=$finder"
      if [[ $strict = true ]]; then
        break
      else
        cmd=$(echo $cmd | sed -E 's/\ {0,1}[^\ ]*$//') # deletes last word
      fi
    done
  fi
}

preexec() {
  if [[ $ZSH_ALIAS_FINDER_AUTOMATIC = true ]]; then
    alias-finder $1
  fi
}
