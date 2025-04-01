fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"

    IFS=$'\n' local num_jobs=($(jobs))
    if [[ "${#num_jobs[@]}" -eq 2 ]]; then
      BUFFER="fg %-"
    fi

    zle accept-line -w
  else
    zle push-input -w
    zle clear-screen -w
  fi
}

zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
