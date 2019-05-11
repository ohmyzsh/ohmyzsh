alias-finder() {
  local cmd=""
  local exact=""
  local longer=""
  for i in $@; do
    case $i in
      -e|--exact) local exact=true;;
      -l|--longer) local longer=true;;
      *) 
        if [[ ! -z $cmd ]]; then
          local cmd="$cmd $i"
        else
          local cmd=$i
        fi
        ;;
    esac
  done
  cmd=$(sed 's/[].\|$(){}?+*^[]/\\&/g' <<< $cmd)
  if [[ $cmd != *\n* ]]; then
    while [[ $cmd != "" ]]; do
      if [[ $longer = true ]]; then
        local wordStart="'{0,1}"
      else
        local wordEnd="$"
        local multiWordEnd="'$"
      fi
      if echo $cmd | grep '^[^ ]*$' > /dev/null; then
        local finder=$wordStart$cmd$wordEnd
      else
        local finder="'$cmd$multiWordEnd"
      fi
      alias | grep -E "=$finder"
      if [[ $exact = true || $longer = true ]]; then
        break
      else
        cmd=$(sed -E 's/ {0,1}[^ ]*$//' <<< $cmd) # deletes last word
      fi
    done
  fi
}

preexec() {
  if [[ $ZSH_ALIAS_FINDER_AUTOMATIC = true ]]; then
    alias-finder $1
  fi
}
