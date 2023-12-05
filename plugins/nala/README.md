# Nala plugin

This plugin adds aliases for [Nala](https://gitlab.com/volian/nala).
It is inspired by the [Ubuntu plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/ubuntu) and is intended for users of that plugin, which is why many of the aliases are in the format `ng*` instead of just `n*`.

To use it, add `nala` to the plugins array in your zshrc file:

```zsh
plugins=(... nala)
```

## Aliases

| Alias | Command                                 | Description                                              |
|-------|-----------------------------------------|----------------------------------------------------------|
| nge   | `sudo nala`                             | Run nala with sudo                                       |
| ngli  | `sudo nala list --installed`            | List the installed packages                              |
| nglu  | `sudo nala list --upgradable`           | List the installed packages that can be upgraded         |
| ngc   | `sudo nala clean`                       | Clear out the local archive of downloaded package files. |
| ngf   | `sudo nala fetch`                       | Fetch fast mirrors to speed up downloads.                |
| ngi   | `sudo nala install`                     | Install packages.                                        |
| ngp   | `sudo nala purge`                       | Purge packages                                           |
| ngr   | `sudo nala remove`                      | Remove packages                                          |
| ngsh  | `sudo nala show`                        | Show package details                                     |
| ngu   | `sudo nala update`                      | Update package list                                      |
| ngug  | `sudo nala upgrade`                     | Update package list and upgrade the system               |
| ngap  | `sudo nala autopurge`                   | Autopurge packages that are no longer needed             |
| ngar  | `sudo nala autoremove`                  | Autoremove packages that are no longer needed            |
| ngs   | `sudo nala search`                      | Search package names and descriptions                    |
| ngh   | `sudo nala history`                     | Show transaction history                                 |
| nghi  | `sudo nala history info`                | Show information about a specific transaction            |
| nghr  | `sudo nala history redo`                | Redo the specified transaction                           |
| nghu  | `sudo nala history undo`                | Undo the specified transaction                           |


## Functions

| Function | Usage                                 | Description                                                                         |
|----------|---------------------------------------|-------------------------------------------------------------------------------------|
| nar      | `nar ppa:xxxxxx/xxxxxx [packagename]` | apt-add-repository with automatic install/upgrade of the desired package using nala |

## Author:
- [@james-horrocks](https://github.com/james-horrocks)

## Ubuntu Plugin Authors:

- [@AlexBio](https://github.com/AlexBio)
- [@dbb](https://github.com/dbb)
- [@Mappleconfusers](https://github.com/Mappleconfusers)
- [@trinaldi](https://github.com/trinaldi)
- [Nicolas Jonas](https://nextgenthemes.com)
- [@loctauxphilippe](https://github.com/loctauxphilippe)
- [@HaraldNordgren](https://github.com/HaraldNordgren)
