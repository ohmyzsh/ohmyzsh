#!/bin/zsh

function omz_usage() {
    echo "Oh My Zsh command line tool. Available commands:"
    echo "   plugin NAME  Enable plugin specified by NAME"
    echo "   theme        Choose theme"
    echo "   upgrade      Upgrade Oh My Zsh"
    echo "   uninstall    Remove Oh My Zsh :("
    echo "   help         Show this help"
}

COMMAND=$1

case $COMMAND in

    plugin )
        shift 1
        source $ZSH/tools/omz-plugin.sh $@
        ;;

    theme )
        zsh $ZSH/tools/theme_chooser.sh
        ;;

    upgrade )
        zsh $ZSH/tools/upgrade.sh
        ;;

    uninstall )
        zsh $ZSH/tools/uninstall.sh
        ;;

    help )
        omz_usage
        ;;

    * )
        omz_usage
        ;;

esac
