# sublime-text-2.plugin.zsh
#
# An oh-my-zsh plugin for Sublime Text 2
# Primarily targetted at OS X ST2 users but this might work for
# Linux as well.
#
SUBL=`which subl`
if [[ $SUBL == 'subl not found' ]] ; then
	if [[ `uname` == 'Darwin' ]] ; then
		if [ -d /Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin ] ; then
			export PATH=/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin:${PATH}
		fi
		if [ -d ~/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin ] ; then
			export PATH=~/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin;${PATH}
		fi
	fi
fi

alias st='subl'
alias stzsh='subl ~/.zshrc'