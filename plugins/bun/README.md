# Bun Plugin

This plugin sets up completion for [Bun](https://bun.sh).

To use it, add `bun` to the plugins array in your zshrc file:

```zsh
plugins=(... bun)
```

This plugin does not add any aliases.

## Cache

This plugin caches the completion script and is automatically updated when the
plugin is loaded, which is usually when you start up a new terminal emulator.

The cache is stored at:

- `$ZSH_CACHE_DIR/completions/_bun_` completions script
