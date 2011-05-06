#!/bin/zsh

# camperdave's full upgrade tool for oh-my-zsh. This tool updates a lot of things that might take a while, so it is seperate tool.
# Created 5/6/2011

# Step one: call the regular update script.
# Step two: check for a custom-overlay. If found, update that.
# Stept three: check each plugin folder, and if there's a .git folder in there, it is independently updated, so update that.

base_upgrade(){
    if [ -z $ZSH ]; then
        if [ -d "~/.oh-my-zsh" ]; then
            export ZSH=~/.oh-my-zsh
        fi
    fi

    if [ -f "$ZSH/tools/upgrade.sh" ]; then
        "$ZSH/tools/upgrade.sh"
    else
        echo "Upgrade script not found!"

        doFresh=1
        while [ $doFresh -eq 1 ]; do
            echo -n "Do you want to install oh-my-zsh to $HOME/.oh-my-zsh? [Y/n] "
            read yn
            case $yn in
                [Yy]* ) git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
                        echo "You should go back up your old .zshrc file, and copy over the one in ~/.oh-my-zshrc/templates..." 
                        break ;;
                [Nn]* ) doFresh=0
                        break ;;
                    * ) echo "Please answer Yes or No." 
                        ;;
                esac   
        done;
    fi    
}


overlay_upgrade(){
    cd "$ZSH"
    echo "Looking for a custom-overlay"
    git remote | grep "custom-overlay"

    if [[ $? == 0 ]]; then
        echo "custom-overlay found. Perfoming update."
        saveIFS=$IFS 
        IFS=$'\n'
        
        doOverlay=1
        while [ $doOverlay -eq 1 ]; do
            set -A badFiles $(git pull -q --no-commit custom-overlay custom-overlay 2>&1)
        
            if [[ ${#badFiles} -gt 0 ]]; then
                echo "$badFiles[2,${#badFiles}-2]"
                echo -n "Do you want to delete the above files in order to pull down your custom overlay? [Y/n] "
                read yn
                case $yn in
                    [Yy]* ) for i in $badFiles[2,${#badFiles}-2]; do
                                val=$(echo $i | sed -e 's/^[ \t]*//')
                                rm "$val"
                            done; 
                            break ;;
                    [Nn]* ) doOverlay=0
                            break ;;
                    * ) echo "Please answer Yes or No." 
                        ;;
                esac
            else
                doOverlay=0
            fi    
        
        done;

        IFS=$saveIFS

        
        # echo $badFiles[2]
    fi

    echo "custom-overlay update completed, performing plugin updates!"
}

plugin_upgrade(){
    cd "$ZSH"
    cd "plugins"
    
    builtin set -A list **
       
    for i in $list; do
        if [ -d "$i/.git" ]; then
    	    echo "Updating $i..."
    	    cd "$i"
    	    git pull
    	    cd ..
        fi
    done
}


# base_upgrade
overlay_upgrade
# plugin_upgrade

cd "$ZSH"
