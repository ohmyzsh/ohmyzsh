#python path ==> brew easy_install and pip are used
export PATH='/usr/local/share/python':$PATH
export HOMEBREW_EDITOR=vim

export PATH=`echo $PATH | sed -e 's|/usr/local/bin||' -e 's|::|:|g'` # Remove /usr/local/bin
export PATH=`echo $PATH | sed -e 's|/usr/bin|/usr/local/bin:&|'`     # Add it in front of /usr/bin
export PATH=`echo $PATH | sed -e 's|/usr/bin|/usr/local/sbin:&|'`    # Add /usr/local/sbin
function brew-link-completion {
  ln -s "$(brew --prefix)/Library/Contributions/brew_zsh_completion.zsh" "$ZSH/plugins/brew/_brew.official"
}
