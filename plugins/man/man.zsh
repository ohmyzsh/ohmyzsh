# ------------------------------------------------------------------------------
# Author
# ------
#
# * Jerry Ling<jerryling315@gmail.com>
#
# ------------------------------------------------------------------------------
# Usgae
# -----
#
# man will be inserted before the command
#
# ------------------------------------------------------------------------------

man-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    [[ $BUFFER != man\ * ]] && LBUFFER="man $LBUFFER"
}
zle -N man-command-line
# Defined shortcut keys: [Esc]man
bindkey "\e"man man-command-line


# ------------------------------------------------------------------------------
# Also, you might want to use man-preview included in 'osx' plugin
# just substitute "man" in the function with "man-preview" after you included OS X in
# the .zshrc