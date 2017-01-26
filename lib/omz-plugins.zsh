# vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={{{,}}} foldlevel=0 foldmethod=marker:
#
#                                   _      _
#                   _o)   __ _  ___/ /__ _/ /_  __ _  (o_
#################   /\\  /  ' \/ _  / _ `/ _  \/  ' \ //\   ##################
#                   \_v /_/_/_/\_,_/\_, /_/ /_/_/_/_/ v_/
#                                  /___/
#
# Author:       Michel Massaro
# Version :     V1.0
# Date :        20/01/17
# Description : 
#
#
##############################################################################


function omz-plugin(){
    if [ $# -ne "1" ] && [ $# -ne "2" ]; then
        echo "Usage: `basename $0` option [plugin_name]"
        echo "option :"
        echo "         update"
        echo "         show"
        echo "         enable  (plugin_name required)"
        echo "         disable (plugin_name required)"
    elif [ "$1" = "update" ]; then
        source ~/.zshrc
        source ~/.zshrc
    elif [ "$1" = "show" ]; then
        printf "\nPre-installed plugins\n"
        printf "---------------------\n"
        printf "%-12s%-25s%s\n" 'Enabled ?' 'Plugin' 'Description'
        for i in $ZSH/plugins/available/*; do
            p=$(basename $i)
            if [ -f "$i/$p.plugin.zsh" ]; then
                description=$(cat "$i/$p.plugin.zsh" | grep 'plugin-description' | sed 's/\#\splugin-description\s:\s//')
            else
                description="Description unreadable. File name no standart"
            fi
            if [ -d $ZSH/plugins/enable/$p ]; then
                is_enable="X"
            else
                is_enable=" "
            fi
            printf "%-12s%-25s%s\n" "[$is_enable]" "$p" "$description"
        done

        printf "\nCustom plugins\n"
        printf "--------------\n"
        printf "%-12s%-25s%s\n" 'Enabled ?' 'Plugin' 'Description'
        for i in $ZSH/custom/plugins/available/*; do
            p=$(basename $i)
            if [ -f "$i/$p.plugin.zsh" ]; then
                description=$(cat "$i/$p.plugin.zsh" | grep 'plugin-description' | sed 's/\#\splugin-description\s:\s//')
            else
                description="Description unreadable. File name no standart"
            fi
            if [ -d $ZSH/custom/plugins/enable/$p ]; then
                is_enable="X"
            else
                is_enable=" "
            fi
            printf "%-12s%-25s%s\n" "[$is_enable]" "$p" "$description"
        done
    elif [ "$1" = "enable" ]; then
        if [ $# -ne "2" ]; then
            echo "Usage: `basename $0` enable plugin_name"
        else
            p=$2
            if [ ! -d "$ZSH/custom/plugins/enable/$p" ] && [ -d "$ZSH/custom/plugins/available/$p" ]; then
                ln -s $ZSH/custom/plugins/available/$p/ $ZSH/custom/plugins/enable/$p
                echo "Plugin $p added in custom"
            elif [ ! -d "$ZSH/plugins/enable/$p" ] && [ -d "$ZSH/plugins/available/$p" ]; then
                ln -s $ZSH/plugins/available/$p/ $ZSH/plugins/enable/$p
                echo "Plugin $p added"
            else
                if [ -d "$ZSH/custom/plugins/enable/$p" ] || [ -d "$ZSH/plugins/enable/$p" ]; then
                    echo "Plugin already enabled"
                else
                    echo "Plugin not found"
                fi
            fi
        fi
    elif [ "$1" = "disable" ]; then
        if [ $# -ne "2" ]; then
            echo "Usage: `basename $0` disable plugin_name"
        else
            p=$2
            if [ -d "$ZSH/custom/plugins/enable/$p" ]; then
                unlink $ZSH/custom/plugins/enable/$p
                echo "Plugin $p removed in custom"
            elif [ -d "$ZSH/plugins/enable/$p" ]; then
                unlink $ZSH/plugins/enable/$p
                echo "Plugin $p removed"
            else
                echo "Plugin not enabled"
            fi
        fi
    else
        echo "Usage: `basename $0` option [plugin_name]"
        echo "option :"
        echo "         update"
        echo "         show"
        echo "         enable  (plugin_name required)"
        echo "         disable (plugin_name required)"
    fi
}
