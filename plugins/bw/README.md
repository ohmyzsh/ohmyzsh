# bw plugin

This plugin adds completion for
[`bw`](https://bitwarden.com/help/cli/), the Bitwarden CLI.

To use it, add `bw` to the plugins array in your zshrc file:

```zsh
plugins=(... bw)
```

This plugin does not add any aliases.

## Cache

This plugin caches the completion script and automatically updates it when the
plugin is loaded, which is usually when you start a new terminal emulator.

The cache is stored at `$ZSH_CACHE_DIR/completions/_bw`.
