# Sublime Text 2 Aliases
#unamestr = 'uname'

if [[ $('uname') == 'Linux' ]]; then
	alias st='/usr/bin/sublime_text&'
elif  [[ $('uname') == 'Darwin' ]]; then
	alias st='/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl'
fi
alias stt='st .'
