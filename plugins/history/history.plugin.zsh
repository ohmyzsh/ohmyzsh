alias h='history'

function hs
{
    history | grep $*
}

alias hsi='hs -i'

# show the most used commands from history
function histop() {
	local FNAME='histop'
	local n=10
	if [[ $# -ne 0 ]]; then
		case $1 in
			-h|--help)
				echo "Usage: $FNAME -n <num>"
				echo "num: print num lines of most used command"
				return 0
				;;
			-n)
				if [ $# -eq 2 -a $2 -ge 1 -a $2 -le $HISTSIZE ]; then
					n=$2
					shift
				else
					echo "option -n needs an number"
					return 1
				fi
				;;
			*)
				echo "$FNAME: Unknown option: $1"
				$FNAME --help
				return 1
				;;
		esac
		shift
	fi
	print "Number\tTimes\tFrequency\tCommand"
	history 1 | awk -v n=$n '{ cmds[$2]++; } END { i = 1; for (cmd in cmds) {
		if (i++ <= n) printf("%-8d%8.2f%%\t%-16s\n", cmds[cmd],
			(100*cmds[cmd])/NR, cmd); else break; }}' | sort -nr | nl
}
