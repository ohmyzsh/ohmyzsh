alias pjo="pj open"

pj () {
    emulate -L zsh

    cmd="cd"
    project=$1

    if [[ "open" == "$project" ]]; then
        shift
        project=$*
        cmd=${=EDITOR}
    else
        project=$*
    fi

    if [[ -z "$project" ]]; then
        echo "You have to specify a project name."
        return
    fi

    for basedir ($PROJECT_PATHS); do
        if [[ -d "$basedir/$project" ]]; then
            $cmd "$basedir/$project"
            return
        fi
    done

    echo "No such project '${project}'."
}

_pj () {
    emulate -L zsh

    typeset -a projects
    for basedir ($PROJECT_PATHS); do
        projects+=(${basedir}/*(/N))
    done

    compadd ${projects:t}
}
compdef _pj pj
