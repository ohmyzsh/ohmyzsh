# HTTPie plugin

This plugin adds completion for [HTTPie](https://httpie.org), a command line HTTP
client, a friendlier cURL replacement.

To use it, add `httpie` to the plugins array in your zshrc file:

```zsh
plugins=(... httpie)
```

It uses completion from [zsh-completions](https://github.com/zsh-users/zsh-completions).

## Aliases

| Alias        | Command                                                          |
| ------------ | ---------------------------------------------------------------- |
| `https`      | `http --default-scheme=https`                                    |

**Maintainer:** [lululau](https://github.com/lululau)
