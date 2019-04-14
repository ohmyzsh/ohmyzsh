preexec() {
  if [[ $1 != *\[*\]* ]] && [[ $1 != *\n* ]]; then
    while [[ $1 != "" ]]; do
      if echo $1 | grep '^[^\ ]*$' > /dev/null; then
        finder=$1
      else
        finder="'$1'"
      fi
      alias | grep "=$finder$"
      1=$(echo $1 | sed -E 's/\ {0,1}[^\ ]*$//') # deletes last word
    done
  fi
}
