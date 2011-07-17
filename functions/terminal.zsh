# Dumb terminals lack support.
if [[ "$TERM" == 'dumb' ]]; then
  return
fi

# Set the GNU Screen window number.
if [[ -n "$WINDOW" ]]; then
  SCREEN_NO="%B$WINDOW%b "
else
  SCREEN_NO=""
fi

# Fully supports GNU Screen, iTerm, and most modern xterm and rxvt terminals.
# Partially supports Mac OS X Terminal since it can't set window and tab separately.
# Usage: title "tab title" "window title"
function terminal-title {
  if [[ "$DISABLE_AUTO_TITLE" != 'true' ]]; then
    if [[ "$TERM" == screen* ]]; then
      # Set GNU Screen's hardstatus (usually truncated at 20 characters).
      printf "\ek%s\e\\" ${(V)1}
    elif [[ "$TERM" == xterm* ]] || [[ "$TERM" == rxvt* ]]; then
      # Set the window title.
      printf "\e]2;%s\a" ${(V)2}
      # Set the tab title (will override window title on a broken terminal).
      printf "\e]1;%s\a" ${(V)1}
    fi
  fi
}

# Don't override precmd/preexec, append to hook array.
autoload -Uz add-zsh-hook

# Set the tab and window titles before the prompt is displayed.
function terminal-title-precmd {
  # 15 character, left-truncated current working directory.
  local terminal_tab_title="${(%):-%15<...<%~%<<}"
  local terminal_window_title="${(%):-%n@%m: %~}"
  terminal-title "$terminal_tab_title" "$terminal_window_title"
}
add-zsh-hook precmd terminal-title-precmd

# Set the tab and window titles before command execution.
function terminal-title-preexec {
  emulate -L zsh
  setopt extended_glob
  # Command name only, or if this is sudo or ssh, the next command.
  local CMD=${1[(wr)^(*=*|sudo|ssh|-*)]}
  local trimmed="${2[1,100]}"
  if [[ "$2" != "$trimmed" ]]; then
    trimmed="${trimmed}..."
  fi
  terminal-title "$CMD" "$trimmed"
}
add-zsh-hook preexec terminal-title-preexec

