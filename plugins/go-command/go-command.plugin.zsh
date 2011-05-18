go() {
  if [ -f "$1" ]; then
    if [ -n "`file $1 | grep '\(text\|empty\|no magic\)'`" ]; then
      $EDITOR "$1"
    else
      if [ -e "`which xdg-open`" ]; then
        if [ -n "$DISPLAY" ]; then
          xdg-open "$1" > /dev/null
        else
          echo "DISPLAY not set:  xdg-open requires X11"
        fi
      elif [ -e "`which cygstart`" ]; then
        cygstart "$1"
      else
        echo "neither xdg-open nor cygstart found:  unable to open '$1'"
      fi
    fi
  elif [ -d "$1" ]; then
    cd "$1"
  elif [ "" = "$1" ]; then
    cd
  elif [ -n "`declare -f | grep '^j ()'`" ]; then
    j "$1"
  else
    echo "Ran out of things to do with '$1'"
  fi
}

alias g=go
