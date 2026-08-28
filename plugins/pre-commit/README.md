# Pre-commit plugin

This plugin adds aliases for common commands of [pre-commit](https://pre-commit.com/).
It also supports [prek](https://github.com/prek/prek) as a drop-in replacement.
If `prek` is available, it will be used; otherwise, `pre-commit` is used as fallback.

To use this plugin, add it to the plugins array in your zshrc file:

```zsh
plugins=(... pre-commit)
```

## Aliases

| Alias | Command                                                | Description                                   |
| ----- | ------------------------------------------------------ | --------------------------------------------- |
| prc   | `prek` or `pre-commit`                                 | The pre-commit command                        |
| prcau | `prek auto-update` or `pre-commit autoupdate`          | Update hooks automatically                    |
| prcr  | `prek run` or `pre-commit run`                         | The pre-commit run command                    |
| prcra | `prek run --all-files` or `pre-commit run --all-files` | Run pre-commit hooks on all files             |
| prcrf | `prek run --files` or `pre-commit run --files`         | Run pre-commit hooks on a given list of files |

