# Dirhistory plugin

This plugin adds keyboard shortcuts for navigating directory history and hierarchy.

To use it, add `dirhistory` to the plugins array in your zshrc file:

```zsh
plugins=(... dirhistory)
```

## Keyboard Shortcuts

| Shortcut                          | Description                                               |
|-----------------------------------|-----------------------------------------------------------|
| <kbd>alt</kbd> + <kbd>left</kbd>  | Go to previous directory                                  |
| <kbd>alt</kbd> + <kbd>right</kbd> | Undo <kbd>alt</kbd> + <kbd>left</kbd>                     |
| <kbd>alt</kbd> + <kbd>up</kbd>    | Move into the parent directory                            |
| <kbd>alt</kbd> + <kbd>down</kbd>  | Move into the first child directory by alphabetical order |

## Usage

This plugin allows you to navigate the history of previous current-working-directories using ALT-LEFT and ALT-RIGHT. ALT-LEFT moves back to directories that the user has changed to in the past, and ALT-RIGHT undoes ALT-LEFT. MAC users may alternately use OPT-LEFT and OPT-RIGHT.

Also, navigate directory **hierarchy** using ALT-UP and ALT-DOWN. (mac keybindings not yet implemented). ALT-UP moves to higher hierarchy (shortcut for 'cd ..'). ALT-DOWN moves into the first directory found in alphabetical order (useful to navigate long empty directories e.g. java packages)

For example, if the shell was started, and the following commands were entered:

```shell
cd ~
cd /usr
cd share
cd doc
```

Then entering ALT-LEFT at the prompt would change directory from /usr/share/doc to /usr/share, then if pressed again to /usr/, then ~. If ALT-RIGHT were pressed the directory would be changed to /usr/ again.

After that, ALT-DOWN will probably go to /usr/bin (depends on your /usr structure), ALT-UP will return to /usr, then ALT-UP will get you to /

**Currently the max history size is 30**. The navigation should work for xterm, PuTTY xterm mode, GNU screen, and on MAC with alternate keys as mentioned above.
