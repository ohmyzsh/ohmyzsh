# GitLab CLI plugin

This plugin adds completion for the [GitLab CLI](https://docs.gitlab.com/cli/).

To use it, add `glab` to the plugins array in your zshrc file:

```zsh
plugins=(... glab)
```

This plugin does not add any aliases.

## Cache

This plugin caches the completion script and is automatically updated when the
plugin is loaded, which is usually when you start up a new terminal emulator.

The cache is stored at:

- `$ZSH/plugins/glab/_glab` completions script

- `$ZSH_CACHE_DIR/glab_version` version of GitLab CLI, used to invalidate
  the cache.
