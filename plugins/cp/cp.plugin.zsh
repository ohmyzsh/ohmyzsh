cpv() {
    rsync -pogb -hhh --backup-dir=/tmp/rsync -e /dev/null --progress -- "$@"
}
compdef _files cpv
