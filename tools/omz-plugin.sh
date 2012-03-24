# Load plugin passed as first arg

if [ -n "$1" ]; then
    PLUGIN="$ZSH/plugins/$1"

    if [ -d $PLUGIN ]; then
        fpath=($PLUGIN $fpath)
        source $PLUGIN/*.plugin.zsh
        autoload -U compinit
        compinit -i
        echo "$1 enabled!"
    else
        echo "Plugin '$1' not found!"
        return 1
    fi
else
    echo "Please specify a plugin"
    return 1
fi
