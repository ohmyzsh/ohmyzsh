src() {
	autoload -U compinit zrecompile
	compinit -i -d "${ZSH_COMPDUMP}"

	for f in ${ZDOTDIR:-~}/.zshrc "${ZSH_COMPDUMP}"; do
		zrecompile -p $f && command rm -f $f.zwc.old
	done

	# Use $SHELL if available; remove leading dash if login shell
	[[ -n "$SHELL" ]] && exec ${SHELL#-} || exec zsh
}
