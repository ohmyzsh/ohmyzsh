# knife_ssh plugin

This plugin adds a `knife_ssh` function as well as completion for it, to allow
connecting via ssh to servers managed with [Chef](https://www.chef.io/).

To use it, add `knife_ssh` to the plugins array in your zshrc file:
```zsh
plugins=(... knife_ssh)
```

The plugin creates a cache of the Chef node list via `knife`, and stores it
in `$HOME/.knife_comp~`, when first triggering knife_ssh completion.

**Requirements:** `knife` has to be installed.
