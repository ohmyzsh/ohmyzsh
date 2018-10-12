# command-not-found plugin

This plugin uses the command-not-found package for zsh to provide suggested packages to be installed if a command cannot be found.

This is installed for Ubuntu as seen in https://www.porcheron.info/command-not-found-for-zsh/

Fedora, OSX and Arch Linux Support are also provided.



To use it, add `command-not-found` to the plugins array of your zshrc file:

```zsh
plugins=(... command-not-found)
```

