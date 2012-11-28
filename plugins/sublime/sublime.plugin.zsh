# Sublime Text 2 Aliases
#unamestr = 'uname'

if [[ $('uname') == 'Linux' ]]; then
	if [ -f '/usr/bin/sublime_text' ]; then
		alias st='/usr/bin/sublime_text&'
	else
		alias st='/usr/bin/sublime-text&'
	fi
elif  [[ $('uname') == 'Darwin' ]]; then
	alias st='/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl'
fi
alias stt='st .'
