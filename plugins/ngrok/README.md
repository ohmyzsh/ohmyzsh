# ngrok plugin

This plugin adds completion for the [ngrok](https://ngrok.com) CLI.

To use it, add `ngrok` to the plugins array in your zshrc file:

```zsh
plugins=(... ngrok)
```

This plugin does not add any aliases.

## Cache

This plugin caches the completion script and is automatically updated asynchronously when the plugin is
loaded, which is usually when you start up a new terminal emulator.

The cache is stored at:

- `$ZSH_CACHE/completions/_ngrok` completions script
