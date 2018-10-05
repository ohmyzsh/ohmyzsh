# Dirhistory plugin

This plugin adds keyboard shortcuts for navigating directory history and hierarchy.

To use it, add `dirhistory` to the plugins array in your zshrc file:

```zsh
plugins=(... dirhistory)
```
## Keyboard Shortcuts

| Shortcut                         | Description                                                |
|----------------------------------|------------------------------------------------------------|
| <kbd>alt</kbd> + <kbd>left</kbd> | Go to previous directory                                   |
| <kbd>alt</kbd> + <kbd>left</kbd> | Undo <kbd>alt</kbd> + <kbd>left</kbd>                      |
| <kbd>alt</kbd> + <kbd>up</kbd>   | Moves to higher directory                                  |
| <kbd>alt</kbd> + <kbd>down</kbd> | Moves into the first directory found in alphabetical order |
