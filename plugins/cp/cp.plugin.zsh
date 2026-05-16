cpv() {
    rsync -pogbr -hhh --backup-dir="/tmp/rsync-${USERNAME}" -e /dev/null --progress "$@"
}
compdef _files cpv
