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
# * Tim D <tim.deh@pm.me>
#
# ------------------------------------------------------------------------------
setopt extendedglob

sudo-off() {
    if [[ $BUFFER == sudoedit\ * ]]; then
        LBUFFER="${LBUFFER#sudoedit }"
        LBUFFER="${EDITOR:t} $LBUFFER"
    elif [[  $BUFFER == sudo\ ${SHELL:t}\ -c\ * ]]; then
        BUFFER="${BUFFER##sudo ${SHELL:t} -c ##[\'\"]#}"
        BUFFER="${BUFFER%[\"\']}"
        BUFFER="${BUFFER//\\\"/\"}"
    else
        LBUFFER="${LBUFFER#sudo }"
   fi
}

sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo(edit)#\ * ]]; then
        sudo-off
    elif [[ $BUFFER == ${EDITOR:t}\ * ]] || [[ $(alias ${BUFFER%% *}) =~ "EDITOR" ]]; then
        LBUFFER="${LBUFFER#${BUFFER%% *} }"
        LBUFFER="sudoedit $LBUFFER"
    elif [[ ${BUFFER//(\"[^\"]#\"|\'[^\']#\')/} =~ '[<>|]'  ]]; then
        BUFFER="sudo zsh -c \"${BUFFER//\"/\\\"}\""
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey -M emacs '\e\e' sudo-command-line
bindkey -M vicmd '\e\e' sudo-command-line
bindkey -M viins '\e\e' sudo-command-line
