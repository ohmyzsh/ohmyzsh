# Macports plugin

This plugin adds completion for the package manager [Macports](https://macports.com/),
as well as some aliases for common Macports commands.

To use it, add `macports` to the plugins array in your zshrc file:

```zsh
plugins=(... macports)
```

## Aliases

| Alias | Command                            | Description                                                  |
|-------|------------------------------------|--------------------------------------------------------------|
| pc    | `sudo port clean --all installed`  | Clean up intermediate installation files for installed ports |
| pi    | `sudo port install`                | Install package given as argument                            |
| psu   | `sudo port selfupdate`             | Update ports tree with MacPorts repository                   |
| puni  | `sudo port uninstall inactive`     | Uninstall inactive ports                                     |
| puo   | `sudo port upgrade outdated`       | Upgrade ports with newer versions available                  |
| pup   | `psu && puo`                       | Update ports tree, then upgrade ports to newest versions     |
