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
		base="${BUFFER#sudo }"
		tokens_slash=("${(@s|/|)base}")
		tokens_space=("${(@s/ /)tokens_slash[-1]}")
		command=("$tokens_space[1]")
		
		BUFFER="nohup $BUFFER &> $command.out &!"
    fi
}
zle -N nohup-command-line
# Defined shortcut keys: [Ctrl] [h]
bindkey "\Ch" nohup-command-line
