# ------------------------------------------------------------------------------
# Author
# ------
#
# * Jerry Ling<jerryling315@gmail.com>
#
# ------------------------------------------------------------------------------
# Usage
# -----
#
# man will be inserted before the command
#
# ------------------------------------------------------------------------------

man-command-line() {
  # if there is no command typed, use the last command
  [[ -z "$BUFFER" ]] && zle up-history

  # prepend man to only the first part of the typed command
  # http://zsh.sourceforge.net/Doc/Release/Expansion.html#Parameter-Expansion-Flags
  if [[ "$BUFFER" == man\ * ]] && return

  # get command and possible subcommand
  ARGS=(${${(Az)BUFFER}[1]} ${${(Az)BUFFER}[2]})

  # check if man page exists
  man "${ARGS[1]}-${ARGS[2]}" > /dev/null 2>&1

  if [[ $? == 0 ]]; then
    BUFFER="man $ARGS"
  else
    BUFFER="man ${ARGS[1]}"
  fi
}
zle -N man-command-line
# Defined shortcut keys: [Esc]man
bindkey "\e"man man-command-line


# ------------------------------------------------------------------------------
# Also, you might want to use man-preview included in 'osx' plugin
# just substitute "man" in the function with "man-preview" after you included OS X in
# the .zshrc
