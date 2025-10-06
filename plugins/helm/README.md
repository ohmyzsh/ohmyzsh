# Helm plugin

This plugin adds completion and aliases for [Helm](https://helm.sh/), the Kubernetes package manager.

To use it, add `helm` to the plugins array in your zshrc file:

```zsh
plugins=(... helm)
```

## Aliases

| Alias |  Full command  |
| ----- | -------------- |
| h     | helm           |
| hin   | helm install   |
| hun   | helm uninstall |
| hse   | helm search    |
| hup   | helm upgrade   |
