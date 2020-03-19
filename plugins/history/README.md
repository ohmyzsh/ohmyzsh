# history plugin

Provides a couple of convenient aliases for using the `history` command to examine your command line history.

To use it, add `history` to the plugins array in your zshrc file:

```zsh
plugins=(... history)
```

## Aliases

| Alias | Command              | Description                                                      |
|-------|----------------------|------------------------------------------------------------------|
| `h`   | `history`            | Prints your command history                                      |
| `hs`  | `history \| grep`    | Use grep to search your command history                          |
| `hsi` | `history \| grep -i` | Use grep to do a case-insensitive search of your command history |
