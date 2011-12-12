# function to send text to primary and secondary clipboards
sendtoclip() {
  if (( $+commands[xclip] )); then
    echo -n $@ | xclip -sel primary
    echo -n $@ | xclip -sel clipboard
  elif (( $+commands[xsel] )); then
    echo -n $@ | xsel -ip # primary
    echo -n $@ | xsel -ib # clipboard
  fi
}
