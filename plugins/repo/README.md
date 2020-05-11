# repo plugin

This plugin mainly adds some aliases and support for automatic completion for
the [repo command line tool](https://code.google.com/p/git-repo/).

To use it, add `repo` to the plugins array in your zshrc file:

```zsh
plugins=(... repo)
```

## Aliases

| Alias   | Command                                |
|---------|----------------------------------------|
| `r`     | `repo`                                 |
| `rra`   | `repo rebase --auto-stash`             |
| `rs`    | `repo sync`                            |
| `rsrra` | `repo sync ; repo rebase --auto-stash` |
| `ru`    | `repo upload`                          |
| `rst`   | `repo status`                          |
| `rsto`  | `repo status -o`                       |
| `rfa`   | `repo forall -c`                       |
| `rfap`  | `repo forall -p -c`                    |
| `rinf`  | `repo info`                            |
