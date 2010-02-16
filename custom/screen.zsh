# don't rename screen window
case "$TERM" in
  screen*)
    preexec () {
      local CMD=${1[(wr)^(*=*|sudo|ssh|-*)]}
      # echo -ne "\ek$CMD\e\\"
      print -Pn "\e]0;%n@%m: $1\a"  # xterm
    }
    precmd () {
      # echo -ne "\ekzsh\e\\"
      print -Pn "\e]0;%n@%m: %~\a"  # xterm
    }
    ;;
esac
