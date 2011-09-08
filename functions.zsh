function title {
  if [ "$TAB_TITLE" != "" ];then 1=$TAB_TITLE;fi
  [ "$DISABLE_AUTO_TITLE" != "true" ] || return
  if [[ "$TERM" == screen* ]]; then 
    print -Pn "\ek$1:q\e\\" #set screen hardstatus, usually truncated at 20 chars
  elif [[ "$TERM" == xterm* ]] || [[ $TERM == rxvt* ]] || [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    print -Pn "\e]2;$2:q\a" #set window name
    print -Pn "\e]1;$1:q\a" #set icon (=tab) name (will override window name on broken terminal)
  fi
}
