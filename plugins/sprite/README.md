# sprite plugin

This plugin adds completion for the [Sprites CLI](https://docs.sprites.dev/cli/installation) (`sprite`).

To use it, add `sprite` to the plugins array in your zshrc file:

```zsh
plugins=(... sprite)
```

This plugin does not add any aliases.

## Cache

This plugin caches the completion script and is automatically updated asynchronously when the plugin is
loaded, which is usually when you start up a new terminal emulator.

The cache is stored at:

- `$ZSH_CACHE_DIR/completions/_sprite` completions script
