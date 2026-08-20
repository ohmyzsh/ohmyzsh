fancy-ctrl-z () {
  local -i hascmd=$(( ${#BUFFER} > 0 ))
  local -a sjobs=("${(@f)$(jobs -s)}")
  local -a opts=("${(@f)$(setopt)}")
  local -i isverbose=$opts[(Ie)verbose]
  # In Zsh, arrays are 1-indexed, and an empty array has size 1, not 0.
  # So we must check the first element's length to see whether it describes a
  # suspended job.
  local -i nsjobs="${#${(@)sjobs}}"
  local -i hassjob=$(( ${#sjobs[1]} > 0 ))
  local -i hassjobs=$(( nsjobs >= 2 ))
  # Whether the ^Z action will result in a side effect to the terminal.
  local -i sideeffect=$(( hassjob || hassjobs || isverbose ))

  if (( hascmd && sideeffect )); then
    # Save the current command.
    # It will be restored after the side-effect is over, e.g., if the
    # foregrounded job is put to the background again.
    zle push-input -w
  fi

  if (( hassjobs )); then
    # Multiple suspended jobs: foreground the second-to-last suspended job.
    BUFFER="fg %-"
    zle accept-line -w
  elif (( hassjob )); then
    # Single suspended job: foreground it.
    # "fg %-" would result in an error as the only suspended job is the
    # last one, which is referenced by "fg" or "fg %+".
    BUFFER="fg %+"
    zle accept-line -w
  elif (( isverbose )); then
    # No suspended jobs, but verbose mode, let show the "fg: no current job".
    BUFFER="fg"
    zle accept-line -w
  fi
}

zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
