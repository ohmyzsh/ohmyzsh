# zsh-syntax-highlighting

This plugin enables Fish-like syntax highlighting for commands as they are typed at a zsh prompt.

To use it, add `zsh-syntax-highlighting` to the end of the plugins array in your zshrc file:

```zsh
plugins=(... zsh-autosuggestions zsh-syntax-highlighting)
```

The plugin must be loaded after plugins that create or wrap ZLE widgets, so it should remain the last plugin
in the array. Start a new terminal session after updating your zshrc file.

For available highlighters and configuration options, see the [upstream documentation](MANUAL.md) and the
[highlighter documentation](docs/highlighters.md).
