# debian

This plugin provides Debian-related aliases and functions for zsh.

To use it add `debian` to the plugins array in your zshrc file.

```zsh
plugins=(... debian)
```

## Settings

- `$apt_pref`: use aptitude or apt if installed, fallback is apt-get.
- `$apt_upgr`: use upgrade or safe-upgrade (for aptitude).

Set **both** `$apt_pref` and `$apt_upgr` to whatever command you want (before sourcing Oh My Zsh) to override this behavior, e.g.:

```sh
apt_pref='apt'
apt_upgr='full-upgrade'
```

## Common Aliases

| Alias  | Command                                                                | Description                                                |
| ------ | ---------------------------------------------------------------------- | ---------------------------------------------------------- |
| `age`  | `apt-get`                                                              | Command line tool for handling packages                    |
| `api`  | `aptitude`                                                             | Same functionality as `apt-get`, provides extra options    |
| `acs`  | `apt-cache search`                                                     | Command line tool for searching apt software package cache |
| `aps`  | `aptitude search`                                                      | Searches installed packages using aptitude                 |
| `as`   | `aptitude -F '* %p -> %d \n(%v/%V)' --no-gui --disable-columns search` | Print searched packages using a custom format              |
| `afs`  | `apt-file search --regexp`                                             | Search file in packages                                    |
| `asrc` | `apt-get source`                                                       | Fetch source packages through `apt-get`                    |
| `app`  | `apt-cache policy`                                                     | Displays priority of package sources                       |

## Superuser Operations Aliases

| Alias    | Command                                                                               | Description                                                                                 |
| -------- | ------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| `aac`    | `sudo $apt_pref autoclean`                                                            | Clears out the local repository of retrieved package files                                  |
| `aar`    | `sudo $apt_pref autoremove`                                                           | Removes packages installed automatically that are no longer needed                          |
| `abd`    | `sudo $apt_pref build-dep`                                                            | Installs all dependencies for building packages                                             |
| `ac`     | `sudo $apt_pref clean`                                                                | Clears out the local repository of retrieved package files except lock files                |
| `ad`     | `sudo $apt_pref update`                                                               | Updates the package lists for upgrades for packages                                         |
| `adg`    | `sudo $apt_pref update && sudo $apt_pref $apt_upgr`                                   | Update and upgrade packages                                                                 |
| `ads`    | `sudo apt-get dselect-upgrade`                                                        | Installs packages from list and removes all not in the list                                 |
| `adu`    | `sudo $apt_pref update && sudo $apt_pref dist-upgrade`                                | Smart upgrade that handles dependencies                                                     |
| `afu`    | `sudo apt-file update`                                                                | Update the files in packages                                                                |
| `ai`     | `sudo $apt_pref install`                                                              | Command-line tool to install package                                                        |
| `ail`    | `sed -e 's/ */ /g' -e 's/ *//' \| cut -s -d ' ' -f 1 \| xargs sudo $apt_pref install` | Install all packages given on the command line while using only the first word of each line |
| `alu`    | `sudo apt update && apt list -u && sudo apt upgrade`                                  | Update, list and upgrade packages                                                           |
| `ap`     | `sudo $apt_pref purge`                                                                | Removes packages along with configuration files                                             |
| `au`     | `sudo $apt_pref $apt_upgr`                                                            | Install package upgrades                                                                    |
| `di`     | `sudo dpkg -i`                                                                        | Install all .deb files in the current directory                                             |
| `dia`    | `sudo dpkg -i ./*.deb`                                                                | Install all .deb files in the current directory                                             |
| `kclean` | `sudo aptitude remove -P ?and(~i~nlinux-(ima\|hea) ?not(~n$(uname -r)))`              | Remove ALL kernel images and headers EXCEPT the one in use                                  |

## Aliases - Commands using `su`

| Alias | Command                                                   |
| ----- | --------------------------------------------------------- |
| `aac` | `su -ls "$apt_pref autoclean" root`                       |
| `aar` | `su -ls "$apt_pref autoremove" root`                      |
| `ac`  | `su -ls "$apt_pref clean" root`                           |
| `ad`  | `su -lc "$apt_pref update" root`                          |
| `adg` | `su -lc "$apt_pref update && aptitude $apt_upgr" root`    |
| `adu` | `su -lc "$apt_pref update && aptitude dist-upgrade" root` |
| `afu` | `su -lc "apt-file update"`                                |
| `au`  | `su -lc "$apt_pref $apt_upgr" root`                       |
| `dia` | `su -lc "dpkg -i ./*.deb" root`                           |

## Miscellaneous Aliases

| Alias     | Command                                        | Description                    |
| --------- | ---------------------------------------------- | ------------------------------ |
| `allpkgs` | `aptitude search -F "%p" --disable-columns ~i` | Display all installed packages |
| `mydeb`   | `time dpkg-buildpackage -rfakeroot -us -uc`    | Create a basic .deb package    |

## Functions

| Function            | Description                                                     |
| ------------------- | --------------------------------------------------------------- |
| `apt-copy`          | Create a simple script that can be used to 'duplicate' a system |
| `apt-history`       | Displays apt history for a command                              |
| `apt-list-packages` | List packages by size                                           |
| `kerndeb`           | Builds kernel packages                                          |

## Authors

- [@AlexBio](https://github.com/AlexBio)
- [@dbb](https://github.com/dbb)
- [@Mappleconfusers](https://github.com/Mappleconfusers)
