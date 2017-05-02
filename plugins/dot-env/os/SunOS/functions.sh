function rgrep {
	if [[ $# -lt 1 ]]; then
		echo "Usage: rgrep PATTERN [PATH]"
		return
	fi
	pattern="$1"
	if [[ -z "$2" ]]; then
		path=`pwd`
	else
		path="$2"
	fi
	find -L "$path"|xargs grep "$pattern"
}
