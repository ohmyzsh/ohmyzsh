# Kitty plugin

This plugin adds a few aliases and functions that are useful for users of the [Kitty](https://sw.kovidgoyal.net/kitty/) terminal.

To use it, add _kitty_ to the plugins array of your zshrc file:
```
plugins=(... kitty)
```

## Plugin commands

* `kssh`
  Runs a kitten ssh session that ensures your terminfo settings are copied
  correctly to the remote hose.
* `kssh-slow`
  A slower form of `kssh` that should always work. Use this if `kssh` fails
  to set terminfo correctly for you on the remote host.
* `kitty-theme`
  Browse and change the theme of your Kitty terminal.

## Contributors

- [Ian Chesal](https://github.com/ianchesal)
