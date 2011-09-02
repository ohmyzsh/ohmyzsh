#!/bin/zsh

function project() {
    cmd="cd"
    file=$1

    if [[ "open" == "$file" ]] then
        file=$2
        cmd=(${(s: :)EDITOR})
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

alias p="project"
alias m="project open"

function _project () {
    compadd `/bin/ls -l $PROJECT_PATHS 2>/dev/null | awk '{ print $8 }'`
}

compdef _project project
