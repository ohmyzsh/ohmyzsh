#!/bin/zsh

function omz_plugin_usage() {
    echo "Usage: omz plugin [options] [plugin]"
    echo "Enable [plugin] in current session"
    echo
    echo "Options"
    echo "  -l   List available plugins"
    echo "  -h   Show this help message"
}

function omz_plugin_exit_clean() {
    unset OMZ_OPTION
    unset OMZ_PLUGIN
    unfunction omz_plugin_usage
    unfunction omz_plugin_exit_clean
    return
}


OPTIND=0
while getopts "lh" OMZ_OPTION
do
    case $OMZ_OPTION in
        l ) ls $ZSH/plugins
            omz_plugin_exit_clean
            return ;;

        * ) omz_plugin_usage
            omz_plugin_exit_clean
            return ;;

    esac
done

if [ -n "$1" ]; then
    OMZ_PLUGIN="$ZSH/plugins/$1"

    if [ -d $OMZ_PLUGIN ]; then
        fpath=($OMZ_PLUGIN $fpath)
        autoload -U compinit
        compinit -i
        if [ -e $OMZ_PLUGIN/$1.plugin.zsh ]; then
            source $OMZ_PLUGIN/$1.plugin.zsh
        fi
        echo "\033[0;32mPlugin $1 enabled"
    else
        echo "\033[1;31mPlugin $1 not found"
    fi
else
    omz_plugin_usage
fi

# Clean global vars
omz_plugin_exit_clean
return
