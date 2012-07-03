# Sublime Text 2 Aliases
#unamestr = 'uname'

if [[ $('uname') == 'Linux' ]]; then
	alias st='/usr/bin/sublime_text&'
elif  [[ $('uname') == 'Darwin' ]]; then
	alias st='open -a /Applications/Sublime Text 2.app'
fi
alias stt='st .'
