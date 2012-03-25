#!/bin/zsh -x

function omz_plugin_usage() {
    echo "Usage: omz plugin [options] [plugin]"
    echo "Enable [plugin] in current session"
    echo
    echo "Options"
    echo "  -l   List available plugins"
    echo "  -h   Show this help message"
}


while getopts ":lh" Option
do
    case $Option in
        l )
            ls $ZSH/plugins
            return ;;

        * ) omz_plugin_usage
            return 1 ;;
    esac
done


if [ -n "$1" ]; then
    PLUGIN="$ZSH/plugins/$1"

    if [ -d $PLUGIN ]; then
        fpath=($PLUGIN $fpath)
        source $PLUGIN/*.plugin.zsh
        autoload -U compinit
        compinit -i
        echo "\033[0;32mPlugin $1 enabled"
        return
    else
        echo "\033[1;31mPlugin $1 not found"
        return 1
    fi
else
    omz_plugin_usage;
    return 1
fi
