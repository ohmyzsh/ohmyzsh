# Grafana CLI plugin

This plugin adds completion for the [Grafana CLI (gcx)](https://github.com/grafana/gcx).

To use it, add `gcx` to the plugins array in your zshrc file:

```zsh
plugins=(... gcx)
```

This plugin does not add any aliases.

## Cache

This plugin caches the completion script and automatically updates it when the
plugin is loaded, which is usually when you start a new terminal emulator.

The cache is stored at `$ZSH_CACHE_DIR/completions/_gcx`.
