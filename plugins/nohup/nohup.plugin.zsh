# ------------------------------------------------------------------------------
# Description
# -----------
#
# nohup will be inserted before the command and a redirect will be appended
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
# * Michele Renda <michele.renda@gmail.com>
#
# ------------------------------------------------------------------------------

nohup-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == nohup\ * ]]; then
        LBUFFER="${LBUFFER#nohup }"
        LBUFFER="${LBUFFER%\ &\>*}"
    else
		tokens=("${(@s/ /)LBUFFER}")
		i=1
		if [[ $tokens[1] == sudo ]]; then
		    (( i++ ))
		fi
		
		LBUFFER="nohup $LBUFFER &> $tokens[$i].out &"
    fi
}
zle -N nohup-command-line
# Defined shortcut keys: [Ctrl] [h]
bindkey "\Ch" nohup-command-line
