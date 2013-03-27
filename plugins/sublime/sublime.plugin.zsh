# Sublime Text 2 Aliases

local _sublime_darwin_paths
_sublime_darwin_paths=(
	"$HOME/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
	"$HOME/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"
	"/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
	"/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"
)

if [[ $('uname') == 'Linux' ]]; then
	if [ -f '/usr/bin/sublime_text' ]; then
		st_run() { nohup /usr/bin/sublime_text $@ > /dev/null & }
	else
		st_run() { nohup /usr/bin/sublime-text $@ > /dev/null & }
	fi
	alias st=st_run

elif  [[ $('uname') == 'Darwin' ]]; then

	for _sublime_path in $_sublime_darwin_paths; do
		if [[ -a $_sublime_path ]]; then
			alias st="'$_sublime_path'"
		fi
	done
fi

alias stt='st .'
