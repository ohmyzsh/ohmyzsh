# Pre-commit plugin

This plugin adds aliases for common commands of [pre-commit](https://pre-commit.com/).

To use this plugin, add it to the plugins array in your zshrc file:

```zsh
plugins=(... pre-commit)
```

## Aliases

| Alias   | Command                                | Description                                            |
| ------- | -------------------------------------- | ------------------------------------------------------ |
| prc     | `pre-commit`                           | The `pre-commit` command                               |
| prcau   | `pre-commit autoupdate`                | Update hooks automatically                             |
| prcr    | `pre-commit run`                       | The `pre-commit run` command                           |
| prcra   | `pre-commit run --all-files`           | Run pre-commit hooks on all files                      |
| prcrf   | `pre-commit run --files`               | Run pre-commit hooks on a given list of files          |
