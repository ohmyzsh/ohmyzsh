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
| pli   | `port livecheck installed`         | Check for updates for installed ports                        |
| plm   | `port-livecheck-maintainer`        | Check for updates of ports maintained by the specified users  |
| psu   | `sudo port selfupdate`             | Update ports tree with MacPorts repository                   |
| puni  | `sudo port uninstall inactive`     | Uninstall inactive ports                                     |
| puo   | `sudo port upgrade outdated`       | Upgrade ports with newer versions available                  |
| pup   | `psu && puo`                       | Update ports tree, then upgrade ports to newest versions     |

## Commands

### port-livecheck-maintainer

```text
Usage:
  port-livecheck-maintainer
  port-livecheck-maintainer (maintainer)+
  port-livecheck-maintainer -h|--help

Check

Options:
  maintainer  maintainer id
  -h          print this help message and exit
```

Checks whether updates are available for ports whose maintainer is the current
user, or any of a specified list of maintainer expressions.  The current user
maintainer id is retrieved as follows:

* The value of the `MACPORTS_MAINTAINER` variable, if set and not null.
* The value of the `USER` variable.
