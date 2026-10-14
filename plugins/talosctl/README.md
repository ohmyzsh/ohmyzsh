# talosctl plugin

This plugin adds completion for the [talosctl](https://docs.siderolabs.com/talos/v1.12/learn-more/talosctl) CLI for managing [Talos](https://github.com/siderolabs/talos) Linux.

To use it, add `talosctl` to the plugins array in your zshrc file:

```zsh
plugins=(... talosctl)
```

This plugin does not add any aliases.

## Cache

This plugin caches the completion script and is automatically updated asynchronously when the plugin is
loaded, which is usually when you start up a new terminal emulator.

The cache is stored at:

- `$ZSH_CACHE/completions/_talosctl` completions script
