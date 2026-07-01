# Helmfile plugin

This plugin adds completion and aliases for [Helmfile](https://helmfile.readthedocs.io/), the declarative helm charts deployer.

To use it, add `helmfile` to the plugins array in your zshrc file:

```zsh
plugins=(... helmfile)
```

## Aliases

| Alias |  Full command          |
| ----- | ---------------------- |
| hf    | helmfile               |
| hfi   | helmfile --interactive |
