#!/bin/zsh

#
# Original idea by DefV (Jan De Poorter)
# Source: https://gist.github.com/pjaspers/368394#comment-1016
#
# Usage:
#  - Set `$PROJECT_PATHS` in your ~/.zshrc
#    e.g.: PROJECT_PATHS=(~/src ~/work)
#  - In ZSH you now can open a project directory with the command: `pj my-project`
#    the plugin will locate the `my-project` directory in one of the $PROJECT_PATHS
#    Also tab completion is supported.
#  - `pjo my-project` will open the directory in $EDITOR
# 

function pj() {
    cmd="cd"
    file=$1

    if [[ "open" == "$file" ]] then
        shift
        file=$*
        cmd=(${(s: :)EDITOR})
    else
        file=$*
    fi

    for project in $PROJECT_PATHS; do
        if [[ -d $project/$file ]] then
            $cmd "$project/$file"
            unset project # Unset project var
            return
        fi
    done

    echo "No such project $1"
}

alias pjo="pj open"

function _pj () {
    # might be possible to improve this using glob, without the basename trick
    typeset -a projects
    projects=($PROJECT_PATHS/*)
    projects=$projects:t 
    _arguments '*:file:($projects)'
}

compdef _pj pj
