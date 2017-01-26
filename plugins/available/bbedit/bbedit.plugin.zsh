alias bbpb='pbpaste | bbedit --clean --view-top'

alias bbd=bbdiff

#
# If the bb command is called without an argument, launch BBEdit
# If bb is passed a directory, cd to it and open it in BBEdit
# If bb is passed a file, open it in BBEdit
#
function bb() {
    if [[ -z "$1" ]]
    then
        bbedit --launch
    else
        bbedit "$1"
        if [[ -d "$1" ]]
        then
            cd "$1"
        fi
    fi
}
