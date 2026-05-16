# "Search files for Front-End"

This plugin adds a few functions for searching files used in Front-End web development.

To use it, add `sfffe` to the plugins array in your zshrc file:
```zsh
plugins=(... sfffe)
```

**Requires:** `ack`

## Functions

- `ajs`: look for string in `.js` files.
- `acss`: look for string in `.css` files.
- `fjs`: search for `.js` files under the current working directory.
- `fcss`: search for `.css` files under the current working directory.
