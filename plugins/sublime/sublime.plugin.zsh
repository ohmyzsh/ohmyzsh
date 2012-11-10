# Sublime Text 2 Aliases
#unamestr = 'uname'

if [[ $('uname') == 'Linux' ]]; then
	st_run() { nohup /usr/bin/sublime_text $@ > /dev/null & }
  	alias st=st_run
elif  [[ $('uname') == 'Darwin' ]]; then
	alias st='/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl'
fi
alias stt='st .'
