# If the tm command is called without an argument, open TextMate in the current directory
# If tm is passed a directory, cd to it and open it in TextMate
# If tm is passed a file, open it in TextMate
function tm() {
	if [[ -z $1 ]]; then
		mate .
	else
		mate $1
		if [[ -d $1 ]]; then
			cd $1
		fi
	fi
}
