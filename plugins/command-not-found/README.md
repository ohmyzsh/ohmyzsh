# command-not-found plugin

This plugin uses the command-not-found package for zsh to provide suggested packages to be installed if a command cannot be found.

This plugin works with the command-not-found package for [Ubuntu](https://www.porcheron.info/command-not-found-for-zsh/), [Arch Linux](https://wiki.archlinux.org/index.php/Pkgfile#Command_not_found), OSX, and Fedora


To use it, add `command-not-found` to the plugins array of your zshrc file:

```zsh
plugins=(... command-not-found)
```

