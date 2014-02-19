#check if we've shelled out from within vim
#if VIMRUNTIME is set, it's likely the shell we are
# in was started from vim.
function shell_from_vim() {
    if [[ -n $VIMRUNTIME ]]; then
        echo 'vim';
    fi
}
