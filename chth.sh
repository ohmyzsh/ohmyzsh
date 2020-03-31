#!/usr/bin/sh

#
## Define colors
#
DEFAULT="\033[00m"
YELLOW="\033[1;33m"
TEAL="\033[1;36m"

#
## function chth for change theme
## change the current ZSH_THEME by the one readed on stdin
## TODO: add error handling on theme selected || autocompletion for theme choice
#
chth() {
	echo -e $YELLOW'Current Theme: '$TEAL $ZSH_THEME $DEFAULT
	read -p $'\e[1;33mEnter new theme: \e[00m' choice
	sed -i -e '/ZSH_THEME=\"./s/'$ZSH_THEME'/'$choice'/g' ~/.zshrc
}
chth
