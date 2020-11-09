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
# * Subhaditya Nath <github.com/subnut>
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

    # Support for aliases to $EDITOR
    () {
        if [[ -z $EDITOR ]]; then                       # EDITOR not set, so no work
            return
        fi
        _EDITOR=$EDITOR                                 # To later restore the original value
        _CURRENT=$(echo -n $BUFFER | cut -d' ' -f1)     # Get current command (to check for alias)
        if [[ $_CURRENT == $EDITOR ]]; then             # If current command is same as EDITOR, no need to check further.
            return 0
        fi
        if [[ $_CURRENT == 'sudoedit' ]]; then          # If current command is sudoedit, no need to check further.
            return 0
        fi
        if [[ $EDITOR =~ ' ' ]]; then
            EDITOR="'$EDITOR"                           # If EDITOR has spaces, then alias will be wrapped in ''
        fi

        # Check for aliases that match the value of $EDITOR
        if
            () {
                for alias in $(alias | grep "=$EDITOR" | cut -d= -f1)
                do  if [[ $alias = $_CURRENT ]]; then
                        EDITOR=$alias   # set EDITOR to the alias
                        return 0
                    fi
                done
                return 1    # none of these aliases match
            };
        then
            return

        # Maybe alias is set to the variable instead of it's value
        elif
            () {
                for alias in $(alias | grep \=\'\$EDITOR | cut -d= -f1)
                do  if [[ $alias = $_CURRENT ]]; then
                        EDITOR=$alias   # set EDITOR to the alias
                        return 0
                    fi
                done
                return 1    # none of these aliases match
            }
        then
            return
        fi

        EDITOR=$_EDITOR     # Nothing matched. Restore $EDITOR
    }

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

    # Restore EDITOR if previously changed
    if [[ -n $_EDITOR ]]; then
        EDITOR=$_EDITOR
    fi
}
zle -N sudo-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey -M emacs '\e\e' sudo-command-line
bindkey -M vicmd '\e\e' sudo-command-line
bindkey -M viins '\e\e' sudo-command-line

# vim: et ts=4
