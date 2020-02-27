# Gitfast plugin

This plugin adds completion for Git, using the zsh completion from git.git folks, which is much faster than the official one from zsh. A lot of zsh-specific features are not supported, like descriptions for every argument, but everything the bash completion has, this one does too (as it is using it behind the scenes). Not only is it faster, it should be more robust, and updated regularly to the latest git upstream version..

To use it, add `gitfast` to the plugins array in your zshrc file:

```zsh
plugins=(... gitfast)
```

## Aliases

An earlier version of the plugin also loaded the git plugin. If you want to keep those
aliases enable the [git plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git)
as well.
