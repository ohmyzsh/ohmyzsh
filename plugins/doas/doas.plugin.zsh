# ------------------------------------------------------------------------------
# Description
# -----------
#
# doas will be inserted before the command
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
# * Dongweiming <ciici123@gmail.com> (original sudo plugin)
# * NeoTheFox <soniczerops@gmail.com> (doas edit)
#
# ------------------------------------------------------------------------------

doas-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == doas\ * ]]; then
        LBUFFER="${LBUFFER#doas }"
    else
        LBUFFER="doas $LBUFFER"
    fi
}
zle -N doas-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey -M emacs '\e\e' doas-command-line
bindkey -M vicmd '\e\e' doas-command-line
bindkey -M viins '\e\e' doas-command-line
