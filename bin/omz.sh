#!/bin/zsh

function omz_usage() {
    echo "Oh My Zsh command line tool. Available commands:"
    echo "  plugin         Manage plugins"
    echo "  theme_chooser  Preview themes"
    echo "  upgrade        Upgrade Oh My Zsh"
    echo "  uninstall      Remove Oh My Zsh :("
    echo "  help           Show this help"
}


OMZ_COMMAND=$1
case $OMZ_COMMAND in

    '' | help )
        omz_usage
        ;;

    plugin )
        shift 1
        source $ZSH/tools/$OMZ_COMMAND.sh $@
        ;;

    * )
        shift 1
        if [ -x $ZSH/tools/$OMZ_COMMAND.sh ]; then
            zsh $ZSH/tools/$OMZ_COMMAND.sh $@
        else
            omz_usage
        fi
        ;;
esac

# Clean global vars
unfunction omz_usage
unset OMZ_COMMAND
