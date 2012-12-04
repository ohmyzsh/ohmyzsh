# Sublime Text 2 Aliases
#unamestr = 'uname'

local _sublime_darwin_subl=/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl

if [[ $('uname') == 'Linux' ]]; then
	if [ -f '/usr/bin/sublime_text' ]; then
		alias st='/usr/bin/sublime_text&'
	else
		alias st='/usr/bin/sublime-text&'
	fi
elif  [[ $('uname') == 'Darwin' ]]; then
	# Check if Sublime is installed in user's home application directory
	if [[ -a $HOME/${_sublime_darwin_subl} ]]; then
		alias st='$HOME/${_sublime_darwin_subl}'
	else
		alias st='${_sublime_darwin_subl}'
	fi
fi
alias stt='st .'
