# debian

This plugin provides debian related zsh aliases.
To use it add `debian` to the plugins array in your zshrc file.

```zsh
plugins=(... debian)
```

## Common Aliases

| Alias    | Command                                                                       | Description                                                                |
| -------- | ------------------------------------------------------------------------------|--------------------------------------------------------------------------- |
| `age`    | apt-get                                                                       | Command line tool for handling packages                                    |
| `api`    | aptitude                                                                      | Same functionality as `apt-get`, provides extra options while installation |
| `acs`    | apt-cache search                                                              | Command line tool for searching apt software package cache                 |
| `aps`    | aptitude search                                                               | Searches installed packages using aptitude                                 |
| `as`     | aptitude -F \"* %p -> %d \n(%v/%V)\" \ -no-gui --disable-columns search       | -                                                                          |
| `afs`    | apt-file search --regexp                                                      | Search file in packages                                                    |
| `asrc`   | apt-get source                                                                | Fetch source packages through `apt-get`                                    |
| `app`    | apt-cache policy                                                              | Displays priority of package sources                                       |

## Superuser Operations Aliases

| Alias    | Command                                                                                          | Description                                                                                 |
| -------- | -------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------- |
| `aac`    | sudo $apt_pref autoclean                                                                         | Clears out the local repository of retrieved package files                                  |
| `abd`    | sudo $apt_pref build-dep                                                                         | Installs all dependencies for building packages                                             |
| `ac`     | sudo $apt_pref clean                                                                             | Clears out the local repository of retrieved package files except lock files                |
| `ad`     | sudo $apt_pref update                                                                            | Updates the package lists for upgrades for packages                                         | 
| `adg`    | sudo $apt_pref update && sudo $apt_pref $apt_upgr                                                | Update and upgrade packages                                                                 |
| `adu`    | sudo $apt_pref update && sudo $apt_pref dist-upgrade                                             | Smart upgrade that handles dependencies                                                     |
| `afu`    | sudo apt-file update                                                                             | Update the files in packages                                                                |
| `au`     | sudo $apt_pref $apt_upgr                                                                         | -                                                                                           |
| `ai`     | sudo $apt_pref install                                                                           | Command-line tool to install package                                                        |
| `ail`    | sed -e 's/  */ /g' -e 's/ *//' &#124; cut -s -d ' ' -f 1 &#124; "' xargs sudo $apt_pref install  | Install all packages given on the command line while using only the first word of each line |
| `ap`     | sudo $apt_pref purge                                                                             | Removes packages along with configuration files                                             |
| `ar`     | sudo $apt_pref remove                                                                            | Removes packages, keeps the configuration files                                             |
| `ads`    | sudo apt-get dselect-upgrade                                                                     | Installs packages from list and removes all not in the list                                 |
| `dia`    | sudo dpkg -i ./*.deb                                                                             | Install all .deb files in the current directory                                             |
| `di`     | sudo dpkg -i                                                                                     | Install all .deb files in the current directory                                             |
| `kclean` | sudo aptitude remove -P ?and(~i~nlinux-(ima&#124;hea) ?not(~n`uname -r`))                        | Remove ALL kernel images and headers EXCEPT the one in use                                  |

- `$apt_pref` - Use apt or aptitude if installed, fallback is apt-get.
- `$apt_upgr` - Use upgrade.

## Aliases - Commands using `su`

| Alias    | Command                                                                       |
| -------- | ------------------------------------------------------------------------------|
| `aac`    | su -ls \'$apt_pref autoclean\' root                                           |
| `ac`     | su -ls \'$apt_pref clean\' root                                               |
| `ad`     | su -lc \'$apt_pref update\' root                                              |
| `adg`    | su -lc \'$apt_pref update && aptitude $apt_upgr\' root                        |
| `adu`    | su -lc \'$apt_pref update && aptitude dist-upgrade\' root                     |
| `afu`    | su -lc "apt-file update                                                       |
| `ag`     | su -lc \'$apt_pref $apt_upgr\' root                                           |
| `dia`    | su -lc "dpkg -i ./*.deb" root                                                 |

## Miscellaneous Aliases

| Alias    | Command                                          | Description                             |
| -------- | -------------------------------------------------|---------------------------------------- |
| `allpkgs`| aptitude search -F "%p" --disable-columns ~i     | Display all installed packages          |  
| `mydeb`  | time dpkg-buildpackage -rfakeroot -us -uc        | Create a basic .deb package             |

## Functions

| Fucntion              | Description                                                                   |
|-----------------------|-------------------------------------------------------------------------------|
| `apt-copy`            | Create a simple script that can be used to 'duplicate' a system               |
| `apt-history`         | Displays apt history for a command                                            | 
| `kerndeb`             | Builds kernel packages                                                        |
| `apt-list-packages`   | List packages by size                                                         |

