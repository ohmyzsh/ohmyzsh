#!/bin/zsh

function omz_usage() {
    echo "Oh My Zsh command line tool. Available commands:"
    echo "  plugin         Manage plugins"
    echo "  theme_chooser  Preview themes"
    echo "  upgrade        Upgrade Oh My Zsh"
    echo "  uninstall      Remove Oh My Zsh :("
    echo "  help           Show this help"
}

COMMAND=$1

case $COMMAND in

    plugin )  # we need source to enable autocompletion
        shift 1
        source $ZSH/tools/$COMMAND.sh $@
        ;;

    * )
        shift 1

        if [ -x $ZSH/tools/$COMMAND.sh ]; then
            zsh $ZSH/tools/$COMMAND.sh $@
        else
            omz_usage
        fi
        ;;

    '' | help )
        omz_usage ;;

esac
