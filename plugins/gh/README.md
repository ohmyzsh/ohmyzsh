# GitHub CLI plugin

This plugin adds completion for the [GitHub CLI](https://cli.github.com/).

To use it, add `gh` to the plugins array in your zshrc file:

```zsh
plugins=(... gh)
```

This plugin does not add any aliases.

## Cache

This plugin caches the completion script and is automatically updated when the
plugin is loaded, which is usually when you start up a new terminal emulator.

The cache is stored at:

- `$ZSH/plugins/gh/_gh` completions script

- `$ZSH_CACHE_DIR/gh_version` version of GitHub CLI, used to invalidate
  the cache.
