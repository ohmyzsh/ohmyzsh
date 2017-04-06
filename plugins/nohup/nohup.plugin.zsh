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
        BUFFER="${BUFFER#nohup }"
        BUFFER="${BUFFER%\ &\>*}"
    else
		tokens_slash=("${(@s|/|)BUFFER}")
		tokens_space=("${(@s/ /)tokens_slash[-1]}")
		i=1
		if [[ $tokens_slash[1] == sudo ]]; then
		    (( i++ ))
		fi
		
		BUFFER="nohup $BUFFER &> $tokens_space[$i].out &"
    fi
}
zle -N nohup-command-line
# Defined shortcut keys: [Ctrl] [h]
bindkey "\Ch" nohup-command-line
