# multipass

This plugin provides completion for [multipass](https://multipass.run), as well as aliases
for multipass commands.

To use it, add `multipass` to the plugins array in your zshrc file:

```zsh
plugins=(... multipass)
```

## Aliases

| Alias  | Command                                                             |
| ------ | ------------------------------------------------------------------- |
| `mp`   | `multipass`                                                         |
| `mpl`  | `multipass list`                                                    |
| `mpla` | `multipass launch`                                                  |
| `mpln` | `multipass launch --network en0 --network name=bridge0,mode=manual` |
| `mps`  | `multipass shell`                                                   |
| `mpsp` | `multipass stop`                                                    |
| `mpst` | `multipass start`                                                   |
