cpv() {
    rsync -pogbr -hhh --backup-dir="/tmp/rsync-${USER:-"$(whoami)"}" -e /dev/null --progress "$@"
}
compdef _files cpv
