# copy the active line from the command line buffer 
# onto the system clipboard (requires clipcopy plugin)

copybuffer () {
  if which clipcopy &>/dev/null; then
    echo $BUFFER | clipcopy
  else
    echo "clipcopy function not found. Please make sure you have Oh My Zsh installed correctly."
  fi
}

zle -N copybuffer

bindkey "^O" copybuffer
