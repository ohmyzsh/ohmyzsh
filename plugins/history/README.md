<<<<<<< HEAD
## history

Provides a couple of convenient aliases for using the `history` command to examine your command line history.

### Requirements

* None.

### Usage

* If `h` is called, your command history is listed. Equivalent to using `history`

* If `hsi` is called with an argument, a **case insensitive** `grep` search is performed on your command history, looking for commands that match the argument provided

* If `hsi` is called without an argument you will help on `grep` arguments
=======
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
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
