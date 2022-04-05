# start fbterm automatically in /dev/tty*

<<<<<<< HEAD
if [[ $(tty|grep -o '/dev/tty') = /dev/tty ]] ; then
	fbterm
	exit
=======
if (( ${+commands[fbterm]} )); then
	if [[ "$TTY" = /dev/tty* ]] ; then
		fbterm && exit
	fi
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
fi
