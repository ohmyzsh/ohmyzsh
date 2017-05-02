# If the am command is called without an argument, open Atom in the current directory
# If am is passed a directory, cd to it and open it in Atom
# If am is passed a file, open it in Atom
function am() {
	if [[ -z $1 ]]; then
		atom .
	else
		atom $1
		if [[ -d $1 ]]; then
			cd $1
		fi
	fi
}
