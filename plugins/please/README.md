# please plugin

[Please](https://please.build) is a cross-language build system with an emphasis on
high performance, extensibility and reproducibility. It supports a number of popular
languages and can automate nearly any aspect of your build process.

This plugin adds autocomplete and major aliases for `plz`, the command line tool for
Please.

To use it, add `please` to the plugins array in your zshrc file:

```zsh
plugins=(... please)
```

## Aliases

| Alias | Command     |
|-------|-------------|
| `pb`  | `plz build` |
| `pt`  | `plz test`  |
| `pw`  | `plz watch` |

## Maintainer

[@thought-machine](https://github.com/thought-machine)
