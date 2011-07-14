# Dumb terminals lack support.
if [[ "$TERM" == 'dumb' ]]; then
  return
fi

# Fully supports GNU Screen, iTerm, and most modern xterm and rxvt terminals.
# Partially supports Mac OS X Terminal since it can't set window and tab separately.
# Usage: title "tab title" "window title"
function title {
  if [[ "$DISABLE_AUTO_TITLE" != 'true' ]]; then
    if [[ "$TERM" == screen* ]]; then
      # Set GNU Screen's hardstatus (usually truncated at 20 characters).
      print -Pn "\ek$1:q\e\\"
    elif [[ "$TERM" == xterm* ]] || [[ "$TERM" == rxvt* ]]; then
      # Set the window title.
      print -Pn "\e]2;$2:q\a"
      # Set the tab title (will override window title on a broken terminal).
      print -Pn "\e]1;$1:q\a"
    fi
  fi
}

# 15 character, left-truncated current working directory.
ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<..<%~%<<"
ZSH_THEME_TERM_TITLE_IDLE="%n@%m: %~"

# Set the tab and window titles before the prompt is displayed.
function precmd {
  title "$ZSH_THEME_TERM_TAB_TITLE_IDLE" "$ZSH_THEME_TERM_TITLE_IDLE"
}

# Set the tab and window titles before command execution.
function preexec {
  emulate -L zsh
  setopt extended_glob
  # Command name only, or if this is sudo or ssh, the next command.
  local CMD=${1[(wr)^(*=*|sudo|ssh|-*)]}
  title "$CMD" "%100>...>$2%<<"
}

