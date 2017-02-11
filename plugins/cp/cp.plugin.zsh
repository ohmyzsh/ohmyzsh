cpv() {
    rsync -pogbr -hhh --backup-dir=/tmp/rsync -e /dev/null --info=progress2 "$@"
}
compdef _files cpv
