# ------------------------------------------------------------------------------
# Description
# -----------
#
# sudo or sudoedit will be inserted before the command
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
# * Dongweiming <ciici123@gmail.com>
#
# ------------------------------------------------------------------------------

sudo-command-line() {
    [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"

    # Save beginning space
    local WHITESPACE=""
    if [[ ${LBUFFER:0:1} == " " ]] ; then 
        WHITESPACE=" "
        LBUFFER="${LBUFFER:1}"
    fi

    if [[ -n $EDITOR && $BUFFER == $EDITOR\ * ]]; then
        if [[ ${#LBUFFER} -le ${#EDITOR} ]]; then
            RBUFFER=" ${BUFFER#$EDITOR }"
            LBUFFER="sudoedit"
        else
            LBUFFER="sudoedit ${LBUFFER#$EDITOR }"
        fi
    elif [[ $BUFFER == sudoedit\ * ]]; then
        if [[ ${#LBUFFER} -le 8 ]]; then
            RBUFFER=" ${BUFFER#sudoedit }"
            LBUFFER="$EDITOR"
        else
            LBUFFER="$EDITOR ${LBUFFER#sudoedit }"
        fi
    elif [[ $BUFFER == sudo\ * ]]; then
        if [[ ${#LBUFFER} -le 4 ]]; then
            RBUFFER="${BUFFER#sudo }"
            LBUFFER=""
        else
            LBUFFER="${LBUFFER#sudo }"
        fi
    else
        LBUFFER="sudo $LBUFFER"
    fi

    # Preserve beginning space
    LBUFFER="${WHITESPACE}${LBUFFER}"
}
zle -N sudo-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey -M emacs '\e\e' sudo-command-line
bindkey -M vicmd '\e\e' sudo-command-line
bindkey -M viins '\e\e' sudo-command-line
