function copy {
    rsync -av --progress -h "$1" "$2"
}

function move {
    rsync -av --progress -h --remove-source-files "$1" "$2"
}

function update {
    rsync -avu --progress -h "$1" "$2"
}

function synchronize {
    rsync -avu --delete --progress -h "$1" "$2"
}
