# Sublime Text 2 Aliases
#unamestr = 'uname'

if [[ $('uname') == 'Linux' ]]; then
        runst() { nohup /usr/bin/sublime-text $@ > /dev/null & }
        alias st=runst
elif  [[ $('uname') == 'Darwin' ]]; then
        alias st='open -a /Applications/Sublime\ Text\ 2.app'
fi
alias stt='st .'

