# ------------------------------------------------------------------------------
# Description
# -----------
#
# sudo will be inserted before the command and the cursor position will be
# preserved. If the prompt is empty, the previously executed command will be
# fetched from the history and prepended with "sudo ".
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
# * Dongweiming <ciici123@gmail.com>
# * Michael Fladischer <FladischerMichael@fladi.at>
#
# ------------------------------------------------------------------------------

sudo_preserve_cursor=1

sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $sudo_preserve_cursor -eq 1 ]]; then
        [[ $LBUFFER != sudo\ * ]] && LBUFFER="sudo $LBUFFER"
    else
        [[ $BUFFER != sudo\ * ]] && BUFFER="sudo $BUFFER"
        zle end-of-line
    fi
}
zle -N sudo-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey "\e\e" sudo-command-line
