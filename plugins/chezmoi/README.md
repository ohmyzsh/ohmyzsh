# chezmoi autocomplete plugin

This plugin adds autocomplete for all [chezmoi](https://www.chezmoi.io/) commands.

Current as of chezmoi v1.8.0.

To use it, add `chezmoi` to the plugins array in your zshrc file:

```zsh
plugins=(... chezmoi)
```

## Additional info

This plugin was created by using this command:

```zsh
chezmoi completion zsh > /tmp/chezmoi.plugin.zsh
```
