#!/usr/bin/sh

#
## Define colors
#
DEFAULT="\033[00m"
YELLOW="\033[1;33m"
TEAL="\033[1;36m"
RED="\033[1;31m"
GREEN="\033[1;32m"

#
## function chth for change theme
## change the current ZSH_THEME by the one readed on stdin
## src:
## - https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/themes/themes.plugin.zsh
##           plugin which ables you to change your theme on your current term
## - man sed
#
chth() {
	echo -e $YELLOW'Current Theme: '$TEAL $ZSH_THEME $DEFAULT
	read -p $'\e[1;33mEnter new theme: \e[00m' choice
    if [[ -f "$ZSH_CUSTOM/$choice.zsh-theme" ]]; then
        sed -i -e '/ZSH_THEME=\"./s/'$ZSH_THEME'/'$choice'/g' ~/.zshrc
    elif [[ -f "$ZSH_CUSTOM/themes/$choice.zsh-theme" ]]; then
        sed -i -e '/ZSH_THEME=\"./s/'$ZSH_THEME'/'$choice'/g' ~/.zshrc
    elif [[ -f "$ZSH/themes/$choice.zsh-theme" ]]; then
        sed -i -e '/ZSH_THEME=\"./s/'$ZSH_THEME'/'$choice'/g' ~/.zshrc
    else
        echo -e $RED'ERROR: the theme selected is not avaible. Please retry with a valid theme.'$DEFAULT
        return 84
    fi
    echo -e $GREEN"Your theme was changed successfully!"$DEFAULT
    return 0
}
chth
