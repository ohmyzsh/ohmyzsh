# ------------------------------------------------------------------------------
# Description
# -----------
#
# run0 will be inserted before the command
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
# * Daniel Braunwarth <oss@braunwarth.dev>
#
# ------------------------------------------------------------------------------

__run0-replace-buffer() {
  local old=$1 new=$2 space=${2:+ }

  # if the cursor is positioned in the $old part of the text, make
  # the substitution and leave the cursor after the $new text
  if [[ $CURSOR -le ${#old} ]]; then
    BUFFER="${new}${space}${BUFFER#$old }"
    CURSOR=${#new}
  # otherwise just replace $old with $new in the text before the cursor
  else
    LBUFFER="${new}${space}${LBUFFER#$old }"
  fi
}

run0-command-line() {
  # If line is empty, get the last run command from history
  [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"

  case "$BUFFER" in
    run0\ *) __run0-replace-buffer "run0" "" ;;
    *) LBUFFER="run0 $LBUFFER" ;;
  esac
}

zle -N run0-command-line

# Defined shortcut keys: [Esc] [Esc]
bindkey -M emacs '\e\e' run0-command-line
bindkey -M vicmd '\e\e' run0-command-line
bindkey -M viins '\e\e' run0-command-line
