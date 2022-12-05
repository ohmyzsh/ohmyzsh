# ------------------------------------------------------------------------------
# Description
# -----------
#
# zsh-script-prefix ./ (replacement for script-prefix) will be inserted before the script
# Based on sudo plugin
#
# ------------------------------------------------------------------------------
# Authors
# -------
# * tmiland <kontakt@tmiland.com>
# - Original sudo script:
# * Dongweiming <ciici123@gmail.com>
# * Subhaditya Nath <github.com/subnut>
# * Marc Cornellà <github.com/mcornella>
# * Carlo Sala <carlosalag@protonmail.com>
#
# ------------------------------------------------------------------------------

__script-prefix-replace-buffer() {
  local old=$1 new=$2

  # if the cursor is positioned in the $old part of the text, make
  # the substitution and leave the cursor after the $new text
  if [[ $CURSOR -le ${#old} ]]; then
    BUFFER="${new}${BUFFER#$old }"
    CURSOR=${#new}
  # otherwise just replace $old with $new in the text before the cursor
  else
    LBUFFER="${new}${LBUFFER#$old }"
  fi
}

script-prefix-command-line() {
  # If line is empty, get the last run command from history
  [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"
      case "$BUFFER" in
        \./\ *) __script-prefix-replace-buffer "./" "" ;;
        *) LBUFFER="./$LBUFFER" ;;
      esac
      return
}

zle -N script-prefix-command-line

# Defined shortcut keys: [Esc]
bindkey -M emacs '\e' script-prefix-command-line
bindkey -M vicmd '\e' script-prefix-command-line
bindkey -M viins '\e' script-prefix-command-line
