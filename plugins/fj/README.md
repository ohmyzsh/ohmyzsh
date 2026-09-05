# Forgejo CLI plugin

This plugin adds completion for the [Forgejo CLI](https://codeberg.org/forgejo-contrib/forgejo-cli).

To use it, add `fj` to the plugins array in your zshrc file:

```zsh
plugins=(... fj)
```

This plugin does not add any aliases.

## Cache

This plugin caches the completion script and is automatically updated when the
plugin is loaded, which is usually when you start up a new terminal emulator.

The cache is stored at:

- `$ZSH/plugins/fj/_fj` completions script

- `$ZSH_CACHE_DIR/fj_version` version of Forgejo CLI, used to invalidate
  the cache.
