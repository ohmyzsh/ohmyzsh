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
