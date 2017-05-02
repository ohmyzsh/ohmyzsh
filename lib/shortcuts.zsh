#!/bin/zsh

# Manage zsh shortcuts simply and easily via the 'shortcut' command
# 
# Shortcuts are added via the 'shortcut' command to which is optionally
# supplied a shortcut name and a target directory.
# 
# - If the directory is omitted then the current directory is assumed.
# - If the shortcut name is omitted then the name of the current directory
#     is used for the shortcut.
# - If a shortcut already exists for the given shortcut name then it will
#     overwrite the current entry.
# 
# Shortcuts get stored in a shortcuts file that is automatically sourced
# each time an entry is added or a shell is started. By default this is in
# the custom directory.
#
#
# Examples:
# 
# Create a shortcut to the ZSH dir accessible by typing 'oh'. 
# ~> shortcut oh ~/.oh-my-sh 
# Adds and entry oh='/home/sgargan/.oh-my-sh' in the shortcuts file
#
# Create a shortcut 'prj' to the current directory. 
# > cd ~/projects
# > shortcut prj
# Adds and entry prj='/home/sgargan/projects' in the shortcuts file
#
# Create a shortcut to the current dir using the name of the current dir e.g.
# > cd ~/projects
# > shortcut
# Adds and entry projects='/home/sgargan/projects' in the shortcuts file
#
# Shortcuts can be deleted using the delete_shortcut command and passing it 
# the name of the shortcut to delete.

# this will get created the first time a shortcut is created.
shortcuts_file=$ZSH/custom/shortcuts/shortcuts

function source_shortcuts () {
    if [[ -e $shortcuts_file ]]; then
        source $shortcuts_file
    fi
}

function create_shortcuts_file () {

    if [[ ! -e $shortcuts_file ]]; then
        local shortcuts_dir=`dirname $shortcuts_file`
        mkdir -p $shortcuts_dir
        touch $shortcuts_file
    fi
}

function _delete () {
    local contains=`grep "$1=" $shortcuts_file`
    if [[ -n $contains ]]; then
        sed -i "/$1=/d" $shortcuts_file
    fi
}

function delete_shortcut () {

    create_shortcuts_file     
    local shortcut=$1
    
    if [[ -z $shortcut ]]; then
        shortcut=`basename $dir`
    fi
    
    echo "Deleting shortcut '$shortcut'"

    _delete $shortcut
    source_shortcuts
}
   
function shortcut () {

    create_shortcuts_file 
    
    local shortcut=$1
    local dir=$2
    
    if [[ -z $dir ]]; then
        dir=`pwd`
    fi

    if [[ -z $shortcut ]]; then
        shortcut=`basename $dir`
    fi
    
    echo "Creating shortcut '$shortcut' to access '$dir'"
    local entry="$shortcut='$dir'"

    _delete $shortcut
    echo $entry >> $shortcuts_file
    cat $shortcuts_file | sort | uniq > /tmp/shortcuts
    mv /tmp/shortcuts $shortcuts_file

    source_shortcuts
}

source_shortcuts


