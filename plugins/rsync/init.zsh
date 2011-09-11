# Aliases
alias rsync-copy='rsync --verbose --progress --human-readable --compress --archive --hard-links'
compdef _rsync rsync-copy=rsync
alias rsync-move='rsync --verbose --progress --human-readable --compress --archive --hard-links --remove-source-files'
compdef _rsync rsync-move=rsync
alias rsync-update='rsync --verbose --progress --human-readable --compress --archive --hard-links --update'
compdef _rsync rsync-upate=rsync
alias rsync-synchronize='rsync --verbose --progress --human-readable --compress --archive --hard-links --update --delete'
compdef _rsync rsync-synchronize=rsync

