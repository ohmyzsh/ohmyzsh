# Ubuntu plugin

This plugin adds completions and aliases for [Ubuntu](https://www.ubuntu.com/).

To use it, add `ubuntu` to the plugins array in your zshrc file: 

```zsh
plugins=(... ubuntu)
```
### Note: 
This plugin was created because the aliases in the debian plugin are inconsistent and hard to remember. Also this apt-priority detection that switched between apt-get and aptitude was dropped to keep it simpler. This plugin uses apt-get for everything but a few things that are only possible with aptitude I guess. Ubuntu does not have aptitude installed by default.

## Aliases
| Alias   | Command                                                                | Description                                                                                       |
|---------|------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------|
| acs     | `apt-cache search`                                                     | Search the apt-cache with the specified criteria                                                  |
| acp     | `apt-cache policy`                                                     | Display the package source priorities                                                             | 
| afs     | `apt-file search --regexp`                                             | Perform a regular expression apt-file search                                                      |
| afu     | `sudo apt-file update`                                                 | Generates or updates the apt-file package database                                                | 
| ag      | `sudo apt-get`                                                         | Run apt-get with sudo                                                                             | 
| aga     | `sudo apt-get autoclean`                                               | Clears out the local reposityory of retrieved package files that can no longer be downloaded      | 
| agb     | `sudo apt-get build-dep <source_pkg>`                                  | Installs/Removes packages to satisfy the dependencies of a specified build pkg                    | 
| agc     | `sudo apt-get clean`                                                   | Clears out the local repository of retrieved package files leaving everything from the lock files | 
| agd     | `sudo apt-get dselect-upgrade`                                         | Follows dselect choices for package installation                                                  | 
| agi     | `sudo apt-get install <pkg>`                                           | Install the specified package                                                                     | 
| agli    | `apt list --installed`                                                 | List the installed packages                                                                       | 
| aglu    | `sudo apt-get -u upgrade --assume-no`                                  | Run an apt-get upgrade assuming no to all prompts                                                 | 
| agp     | `sudo apt-get purge <pkg>`                                             | Remove a package including any configuration files                                                | 
| agr     | `sudo apt-get remove <pkg>`                                            | Remove a package                                                                                  | 
| ags     | `apt source <pkg>`                                                     | Fetch the source for the specified package                                                        | 
| agu     | `sudo apt-get update`                                                  | Update package list                                                                               | 
| agud    | `sudo apt-get update && sudo apt-get dist-upgrade`                     | Update packages list and perform a distribution upgrade                                           | 
| agug    | `sudo apt-get upgrade`                                                 | Upgrade available packages                                                                        | 
| agar    | `sudo apt-get autoremove`                                              | Remove automatically installed packages no longer needed                                          | 
| aguu    | `sudo apt-get update && sudo apt-get upgrade`                          | Update packages list and upgrade available packages                                               | 
| allpkgs | `dpkg --get-selections | grep -v deinstall`                            | Print all installed packages                                                                      | 
| kclean  | `sudo aptitude remove -P ?and(~i~nlinux-(ima|hea) ?not(~n`uname -r`))` |Remove ALL kernel images and headers EXCEPT the one in use                                         |
| mydeb   | `time dpkg-buildpackage -rfakeroot -us -uc`                            | Create a basic .deb package                                                                       |
| ppap    | `sudo ppa-purge <ppa>`                                                 | Remove the specified PPA                                                                          | 


## Functions
| Function          | Usage                                 |Description                                                               |
|-------------------|---------------------------------------|--------------------------------------------------------------------------|
| aar               | `aar ppa:xxxxxx/xxxxxx [packagename]` | apt-add-repository with automatic install/upgrade of the desired package |
| apt-history       | `apt-history <action>`                | Prints the Apt history of the specified action                           |
| apt-list-packages | `apt-list-packages`                   | List packages by size                                                    |
| kerndeb           | `kerndeb`                             | Kernel-package building shortcut                                         | 


