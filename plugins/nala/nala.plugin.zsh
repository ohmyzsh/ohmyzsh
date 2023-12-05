#List all installed packages
alias ngli='nala list --installed'

# List available updates only
alias nglu='nala list --upgradable'

# superuser operations ######################################################
alias nge="sudo nala"
alias ngc="sudo nala clean"
alias ngf="sudo nala fetch"
alias ngi="sudo nala install"
alias ngp="sudo nala purge"
alias ngr="sudo nala remove"
alias ngsh="sudo nala show"
alias ngu="sudo nala update"
alias ngug="sudo nala upgrade"
alias ngap="sudo nala autopurge"
alias ngar="sudo nala autoremove"
alias ngs="sudo nala search"

alias ngh="sudo nala history"
alias nghi="sudo nala history info"
alias nghr="sudo nala history redo"
alias nghu="sudo nala history undo"

# apt-add-repository with automatic install/upgrade of the desired package
# Usage: aar ppa:xxxxxx/xxxxxx [packagename]
# If packagename is not given as 2nd argument the function will ask for it and guess the default by taking
# the part after the / from the ppa name which is sometimes the right name for the package you want to install
function nar() {
	if [ -n "$2" ]; then
		PACKAGE=$2
	else
		read "PACKAGE?Type in the package name to install/upgrade with this ppa [${1##*/}]: "
	fi

	if [ -z "$PACKAGE" ]; then
		PACKAGE=${1##*/}
	fi

	sudo apt-add-repository $1 && sudo nala update
	sudo nala install $PACKAGE
}
