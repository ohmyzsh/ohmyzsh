# Argo CD plugin

This plugin adds completion for the [Argo CD](https://argoproj.github.io/cd/) CLI.

To use it, add `argocd` to the plugins array in your zshrc file:

```zsh
plugins=(... argocd)
```

This plugin does not add any aliases.

## Cache

This plugin caches the completion script and is automatically updated asynchronously when the plugin is
loaded, which is usually when you start up a new terminal emulator.

The cache is stored at:

- `$ZSH_CACHE/completions/_argocd` completions script
