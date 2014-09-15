# first manually install homeshick via:
# git clone git://github.com/andsens/homeshick.git $HOME/.homesick/repos/homeshick

# make sure homeshick is available
if [ -f $HOME/.homesick/repos/homeshick/homeshick.sh ]; then

	# adding homeshick to path
	. $HOME/.homesick/repos/homeshick/homeshick.sh

	# enable homeshick zsh completition (see official docs: https://github.com/andsens/homeshick/wiki/Installation#zsh-completion)
	fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

	# make autocompletition happen (workaround for: https://github.com/andsens/homeshick/issues/89)
	compinit

	# useful aliases
	alias hsckl="homeshick pull"
fi

