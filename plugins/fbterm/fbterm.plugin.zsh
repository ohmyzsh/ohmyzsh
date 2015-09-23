# start fbterm automatically in /dev/tty*

if (( ${+commands[fbterm]} )); then
	if [[ "$TTY" = /dev/tty* ]] ; then
		fbterm && exit
	fi
fi
