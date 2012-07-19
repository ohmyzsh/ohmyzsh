# Sublime Text 2 Aliases
alias st='/usr/bin/subl'
#unamestr = 'uname'

if [[ $('uname') == 'Linux' ]]; then
	alias st='/usr/bin/sublime_text&'
elif  [[ $('uname') == 'Darwin' ]]; then
	alias st='/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl'
fi

alias stt='st .'
