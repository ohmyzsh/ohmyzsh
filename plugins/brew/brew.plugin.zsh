# Move /usr/local/bin (path where brews are linked) to the front of the path
# This will allow us to override system binaries like ruby with our brews
# TODO: Do this in a more compatible way.
#       What if someone doesn't have /usr/bin in their path?
export PATH=`echo $PATH | sed -e 's|/usr/local/bin||' -e 's|::|:|g'` # Remove /usr/local/bin
export PATH=`echo $PATH | sed -e 's|/usr/bin|/usr/local/bin:&|'`     # Add it in front of /usr/bin
export PATH=`echo $PATH | sed -e 's|/usr/bin|/usr/local/sbin:&|'`    # Add /usr/local/sbin

alias brews='brew list -1'

function brew-link-completion {
	ln -s "$(brew --prefix)/Library/Contributions/brew_zsh_completion.zsh" "$ZSH/plugins/brew/_brew.official"
}
