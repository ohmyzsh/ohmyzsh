# logcli plugin

This plugin adds completion for [Grafana Loki's logcli](https://grafana.com/docs/loki/latest/query/logcli/).

To use it, add `logcli` to the plugins array in your zshrc file:

```zsh
plugins=(... logcli)
```

This plugin does not add any aliases.

## Cache

This plugin caches the completion script and automatically updates it when the
plugin is loaded, which is usually when you start a new terminal emulator.

The cache is stored at `$ZSH_CACHE_DIR/completions/_logcli`.
