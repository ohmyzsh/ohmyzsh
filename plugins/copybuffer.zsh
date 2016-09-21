# copy the active line from the command line buffer 
# onto the system clipboard (requires clipcopy plugin)

copybuffer () {
  if which clipcopy &>/dev/null; then
    echo $BUFFER | clipcopy
  else
    echo "you must install clipcopy to use this keybinding"
  fi
}

zle -N copybuffer

bindkey "^O" copybuffer
