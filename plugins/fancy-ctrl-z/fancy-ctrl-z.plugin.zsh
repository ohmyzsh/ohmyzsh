case "${(L)FANCY_CTRL_Z_FLIP_FLOP:-false}" in
  (true|yes|on|1)
    FANCY_CTRL_Z_FLIP_FLOP=1
    ;;
  *)
    FANCY_CTRL_Z_FLIP_FLOP=0
    ;;
esac

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
  local -i isflipflop=$(( FANCY_CTRL_Z_FLIP_FLOP == 1 ))
  # Whether the ^Z action will result in a side effect to the terminal.
  local -i sideeffect=$(( hassjob || hassjobs || isverbose ))

  if (( hascmd && sideeffect )); then
    # Save the current command.
    # It will be restored after the side-effect is over, e.g., if the
    # foregrounded job is put to the background again.
    zle push-input -w
  fi

  if (( hassjobs && isflipflop )); then
    # Multiple suspended jobs: foreground the second-to-last suspended job, if
    # flip-flop mode is enabled.
    BUFFER="fg %-"
    zle accept-line -w
  elif (( hassjob || (hassjobs && !isflipflop) )); then
    # Single suspended job or multiple suspended jobs without fli-flop:
    # foreground it, or the most recently suspended one.
    #
    # The above "fg %-" would result in an error as in the "only one job" case,
    # the suspended job is also the last one, which is referenced by "fg %+".
    BUFFER="fg %+"
    zle accept-line -w
  elif (( isverbose )); then
    # No suspended jobs, but verbose mode, allow showing the
    # "fg: no current job" error message.
    BUFFER="fg"
    zle accept-line -w
  fi
}

zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
