# start fbterm automatically in /dev/tty*

if [[ $(tty|grep -o '/dev/tty') = /dev/tty ]] ; then
	fbterm
	exit
fi
