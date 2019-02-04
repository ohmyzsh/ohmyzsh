# Ubuntu plugin

This plugin adds completions and aliases for [Ubuntu](https://www.ubuntu.com/).

To use it, add `ubuntu` to the plugins array in your zshrc file: 

```zsh
plugins=(... ubuntu)
```

## Aliases

Commands that use `$APT` will use apt if installed or defer to apt-get otherwise. 

| Alias    | Command                                                                | Description                                                                                       |
|----------|------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------|
| acs      | `apt-cache search`                                                     | Search the apt-cache with the specified criteria                                                  |
| acp      | `apt-cache policy`                                                     | Display the package source priorities                                                             | 
| afs      | `apt-file search --regexp`                                             | Perform a regular expression apt-file search                                                      |
| safu     | `sudo apt-file update`                                                 | Generates or updates the apt-file package database                                                | 
| sag      | `sudo $APT`                                                            | Run apt-get with sudo                                                                             | 
| saga     | `sudo $APT autoclean`                                                  | Clears out the local reposityory of retrieved package files that can no longer be downloaded      | 
| sagb     | `sudo $APT build-dep <source_pkg>`                                     | Installs/Removes packages to satisfy the dependencies of a specified build pkg                    | 
| sagc     | `sudo $APT clean`                                                      | Clears out the local repository of retrieved package files leaving everything from the lock files | 
| sagd     | `sudo $APT dselect-upgrade`                                            | Follows dselect choices for package installation                                                  | 
| sagi     | `sudo $APT install <pkg>`                                              | Install the specified package                                                                     | 
| agli     | `apt list --installed`                                                 | List the installed packages                                                                       | 
| saglu    | `sudo apt-get -u upgrade --assume-no`                                  | Run an apt-get upgrade assuming no to all prompts                                                 | 
| sagp     | `sudo $APT purge <pkg>`                                                | Remove a package including any configuration files                                                | 
| sagr     | `sudo $APT remove <pkg>`                                               | Remove a package                                                                                  | 
| ags      | `$APT source <pkg>`                                                    | Fetch the source for the specified package                                                        | 
| sagu     | `sudo $APT update`                                                     | Update package list                                                                               | 
| sagud    | `sudo $APT update && sudo $APT dist-upgrade`                           | Update packages list and perform a distribution upgrade                                           | 
| sagug    | `sudo $APT upgrade`                                                    | Upgrade available packages                                                                        | 
| sagar    | `sudo $APT autoremove`                                                 | Remove automatically installed packages no longer needed                                          | 
| saguu    | `sudo $APT update && sudo $APT upgrade`                                | Update packages list and upgrade available packages                                               | 
| allpkgs  | `dpkg --get-selections \| grep -v deinstall`                           | Print all installed packages                                                                      | 
| skclean  | `sudo aptitude remove -P ?and(~i~nlinux-(ima\|hea) ?not(~n$(uname -r)))`  |Remove ALL kernel images and headers EXCEPT the one in use                                         |
| mydeb    | `time dpkg-buildpackage -rfakeroot -us -uc`                            | Create a basic .deb package                                                                       |
| sppap    | `sudo ppa-purge <ppa>`                                                 | Remove the specified PPA                                                                          | 


## Functions

| Function          | Usage                                 |Description                                                               |
|-------------------|---------------------------------------|--------------------------------------------------------------------------|
| aar               | `aar ppa:xxxxxx/xxxxxx [packagename]` | apt-add-repository with automatic install/upgrade of the desired package |
| apt-history       | `apt-history <action>`                | Prints the Apt history of the specified action                           |
| apt-list-packages | `apt-list-packages`                   | List packages by size                                                    |
| kerndeb           | `kerndeb`                             | Kernel-package building shortcut                                         | 


