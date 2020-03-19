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
    [[ "$BUFFER" != man\ * ]] && BUFFER="man ${${(Az)BUFFER}[1]}"
}
zle -N man-command-line
# Defined shortcut keys: [Esc]man
bindkey "\e"man man-command-line


# ------------------------------------------------------------------------------
# Also, you might want to use man-preview included in 'osx' plugin
# just substitute "man" in the function with "man-preview" after you included OS X in
# the .zshrc
