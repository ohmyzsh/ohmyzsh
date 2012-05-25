# Sublime Text 2 Aliases

unamestr=`uname`

if [[ "$unamestr" == 'Darwin' ]]; then
        alias st='/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl'
        alias stt='st .'
elif [[ "$unamestr" == 'Linux' ]]; then
        alias st='/usr/bin/sublime-text-2'
        alias stt='/usr/bin/sublime-text-2 .'
fi