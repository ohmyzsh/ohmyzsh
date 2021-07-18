beginning-of-buffer() {
  CURSOR=0
  return 0
}

end-of-buffer() {
  CURSOR=${#BUFFER}
  return 0
}

zle -N beginning-of-buffer
zle -N end-of-buffer
