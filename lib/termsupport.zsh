#usage: title short_tab_title looooooooooooooooooooooggggggg_windows_title
#http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#ss3.1
#Fully support screen, iterm, and probably most modern xterm and rxvt
#Limited support for Apple Terminal (Terminal can't set window or tab separately)
function title {
  [ "$DISABLE_AUTO_TITLE" != "true" ] || return
  if [[ "$TERM" == screen* ]]; then
    print -Pn "\ek$1:q\e\\" #set screen hardstatus, usually truncated at 20 chars
  elif [[ "$TERM" == xterm* ]] || [[ $TERM == rxvt* ]] || [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    print -Pn "\e]2;$2:q\a" #set window name
    print -Pn "\e]1;$1:q\a" #set icon (=tab) name (will override window name on broken terminal)
  fi
}

ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<%~%<<" #15 char left truncated PWD
ZSH_THEME_TERM_TITLE_IDLE="%n@%m: %~"

#Appears when you have the prompt
function omz_termsupport_precmd {
  title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE
}

#Appears at the beginning of (and during) of command execution
function omz_termsupport_preexec {
  emulate -L zsh
  setopt extended_glob
  local CMD=${1[(wr)^(*=*|sudo|ssh|-*)]} #cmd name only, or if this is sudo or ssh, the next cmd
  title "$CMD" "%100>...>$2%<<"
}

# Prints given 2nd argument with xterm color code of 1st argument
# see http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html for color codes
function xterm_color() {
  echo -e "%{\033[38;5;$1m%}$2%{\033[0m%}"
}

function xterm_color_open() {
  echo -e "%{\033[38;5;$1m%}"
}

function xterm_color_reset() {
  echo -e "%{\033[0m%}"
}

function _show_colors() {
 T='■'   # The test text
 
 echo -e "\n           40m 41m 42m 43m 44m 45m 46m 47m"; 
 
 for FGs in '    m' '   1m' '  30m' '1;30m' \
            '  31m' '1;31m' '  32m' '1;32m' \
            '  33m' '1;33m' '  34m' '1;34m' \
            '  35m' '1;35m' '  36m' '1;36m' \
            '  37m' '1;37m';
   do FG=${FGs// /}
   echo -en " $FGs \033[$FG $T "
   for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
 	do echo -en "$EINS \033[$FG\033[$BG $T \033[0m";
   done
   echo;
 done
}

autoload -U add-zsh-hook
add-zsh-hook precmd  omz_termsupport_precmd
add-zsh-hook preexec omz_termsupport_preexec
