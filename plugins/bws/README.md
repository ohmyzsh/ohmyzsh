# bws plugin

This plugin adds completion for
[`bws`](https://github.com/bitwarden/sdk-sm), the Bitwarden Secrets Manager CLI.

To use it, add `bws` to the plugins array in your zshrc file:

```zsh
plugins=(... bws)
```

This plugin does not add any aliases.

## Cache

This plugin caches the completion script and automatically updates it when the
plugin is loaded, which is usually when you start a new terminal emulator.

The cache is stored at `$ZSH_CACHE_DIR/completions/_bws`.
