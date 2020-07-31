#!/bin/zsh

# Compile Oh My Zsh
# This compiles the ohmyzsh files with zcompile, should be called when changing
# a configuration file(.zshrc, .zshenv, ...) or updating ohmyzsh. Compiling a
# those files remove the over head of the text parsing.

if [[ -n $ZDOTDIR ]]; then
	zsh_dir=$ZDOTDIR
else
	zsh_dir=$HOME
fi

FILE_LIST=(
	"$zsh_dir/.zshrc"
	"$zsh_dir/.zshenv"
	"$zsh_dir/.zprofile"
	"$zsh_dir/.zlogin"
	"$zsh_dir/.zlogout"
	"$ZSH/oh-my-zsh.sh"
)

DIRECTORY_LIST=(
	"$ZSH/lib"
	"$ZSH/themes"
	"$ZSH/custom"
)

function compile_directory() {
	if [[ ! -d $1 ]]; then
		echo "The path \"$1\" is not a direcorty or does not exist"
		exit
	fi
	for i in "$1"/**/*; do
		if [[ -f "$i"  &&  "$i" == *.zsh || $i == *.sh || $i == *.zsh-theme ]]
		then
			zcompile "$i"
		fi
	done
}

function compile_file() {
	[ -f "$1" ] && zcompile "$1"
}

function clean() {
	for i in "${FILE_LIST[@]}"; do
		rm -f "$i.zwc"
	done
	for i in "${DIRECTORY_LIST[@]}"; do
		for j in "$i"/**/*; do
			rm -f "$j.zwc"
		done
	done
	exit
}

function main() {
	for arg in "$@"; do
		case $arg in
			-h|--help)
				usage
				exit 0;;
			--clean)
				clean=true;;
		esac
	done	

	if [[ -n $clean ]]; then
		clean
	fi

	for i in "${FILE_LIST[@]}"; do
		compile_file "$i"
	done

	for i in "${DIRECTORY_LIST[@]}"; do
		compile_directory "$i"
	done
}

function usage(){
	cat <<EOF
compile_ohmyzsh.sh 
Compile all the configuration file for zsh and OhMyZsh

USAGE:
	require_tool.sh [OPTIONS]

OPTIONS
	-h, --help          Display this message and exit 0
	    --clean         Removes all the compiled files
EOF
}


# Main
main "$@"
