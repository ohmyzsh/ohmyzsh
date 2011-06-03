# Thanks to Christopher Sexton
# https://gist.github.com/965032
function kapow {
	touch ~/.pow/$1/tmp/restart.txt
	if [ $? -eq 0 ]; then
		echo "$fg[yellow]Pow restarting $1...$reset_color"
	fi
}

compctl -W ~/.pow -/ kapow
