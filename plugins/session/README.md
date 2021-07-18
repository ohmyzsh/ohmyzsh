Terminal.app on macOS provides the `TERM_SESSION_ID` environment variable into every shell process.  
Out of the box, for bash, it allows one to define the `shell_session_save_user_state` function which  
can write any shell command to the `SHELL_SESSION_FILE` file.

If user then exit Terminal.app with open sessions, this function will be called for each of them.  
On the next launch, Terminal.app will source session files into corresponding sessions.

This plugin implements that logic for Zsh.

E.g. to automatically restore Python's virtual environment, just add the following to you `.zshrc`:

```zsh
function shell_session_save_user_state() {
    # Resulting files is sourced at the very beginning,
    # which maybe to early.
    # It's better to have control over when session should be restored.
    echo "function restore_session() {" >> $SHELL_SESSION_FILE

    if [[ -n ${VIRTUAL_ENV} ]]; then
        echo source \"${VIRTUAL_ENV}\"/bin/activate >> $SHELL_SESSION_FILE
    fi

    echo "}" >> $SHELL_SESSION_FILE
}

if typeset -f restore_session >/dev/null; then
    restore_session
fi
```
