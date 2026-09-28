# GitLab CLI plugin

This plugin adds completion for the [GitLab CLI](https://docs.gitlab.com/cli/).

To use it, add `glab` to the plugins array in your zshrc file:

```zsh
plugins=(... glab)
```

This plugin does not add any aliases.

## Cache

This plugin caches the completion script at `$ZSH_CACHE_DIR/completions/_glab`.

The cache is regenerated in the background whenever the plugin is loaded, which
usually happens when you start a new Zsh session.
