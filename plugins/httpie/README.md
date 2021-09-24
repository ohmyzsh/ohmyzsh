# HTTPie plugin

This plugin provides many [aliases](#aliases) and adds completion for [HTTPie](https://httpie.org), a command line HTTP client, a friendlier cURL replacement.

To use it, add `httpie` to the plugins array in your zshrc file:

```zsh
plugins=(... httpie)
```
## Completion

It uses completion from [zsh-completions](https://github.com/zsh-users/zsh-completions).

## Aliases

| Alias        | Command                                                          |
| ------------ | ---------------------------------------------------------------- |
| `https`      | `http --default-scheme=https`                                    |
| `GET`        | http -v GET |
| `POST`       | http -v POST |
| `PUT`        | http -v PUT |
| `PATCH`      | http -v PATCH |
| `DELETE`     | http -v DELETE |
| `OPTION`     | http -v OPTION |

**Maintainer:** [lululau](https://github.com/lululau)
